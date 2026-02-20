import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current logged-in user (custom model)
  User? _currentUser;

  // Getters
  User? get currentUser => _currentUser;

  // Initialize auth service and load saved users
  Future<void> initialize() async {
    // Listen to Firebase Auth state changes for future updates
    _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        // User is signed in
        if (_currentUser == null || _currentUser?.email != firebaseUser.email) {
          try {
            await _fetchUserDetails(firebaseUser.uid);
          } catch (e) {
            debugPrint('Error initializing sub user details: $e');
          }
        }
      } else {
        // User is signed out
        _currentUser = null;
        notifyListeners();
      }
    });

    // Initial check to populate _currentUser before app starts
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        await _fetchUserDetails(firebaseUser.uid);
      } catch (e) {
        debugPrint('Error initializing user details: $e');
      }
    }
  }

  // Fetch user details from Firestore
  Future<void> _fetchUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        _currentUser = User.fromJson(doc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      rethrow;
    }
  }

  // Sign up a new user (Logs in automatically - for self registration)
  Future<bool> signUp({
    required String email,
    required String password,
    required String userType,
    String? fullName,
    String? phoneNumber,
    String? assignedZone,
  }) async {
    try {
      // Create user in Firebase Auth
      firebase_auth.UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        // Create user model
        final newUser = User(
          email: email,
          userType: userType,
          fullName: fullName,
          phoneNumber: phoneNumber,
          assignedZone: assignedZone,
        );

        // Save user details to Firestore
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(newUser.toJson());

        // Update local state
        _currentUser = newUser;
        notifyListeners();
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration failed");
    } catch (e) {
      debugPrint('Sign up error: $e');
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  // Create a collector account WITHOUT logging out the current admin
  Future<void> createCollectorAccount({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? assignedZone,
  }) async {
    firebase_auth.FirebaseAuth? secondaryAuth;
    // We need to access the current FirebaseApp options to initialize a secondary app
    final firebase_core.FirebaseApp app = firebase_core.Firebase.app();

    try {
      // Initialize a secondary Firebase App to create the user without signing out the admin
      final secondaryApp = await firebase_core.Firebase.initializeApp(
        name: 'SecondaryApp',
        options: app.options,
      );

      secondaryAuth = firebase_auth.FirebaseAuth.instanceFor(app: secondaryApp);

      // Create the user in the secondary app
      firebase_auth.UserCredential credential = await secondaryAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        final newUser = User(
          email: email,
          userType: 'Garbage Collector',
          fullName: fullName,
          phoneNumber: phoneNumber,
          assignedZone: assignedZone,
        );

        // Use the MAIN Firestore instance to save data (admin has permission)
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(newUser.toJson());

        // Sign out from the secondary app just to be clean, though we are deleting it
        await secondaryAuth.signOut();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to create collector");
    } catch (e) {
      throw Exception("Error creating collector: $e");
    } finally {
      // Delete the secondary app to clean up
      if (secondaryAuth != null) {
        // Note: delete() is on the FirebaseApp instance
        final appToDelete = firebase_core.Firebase.app('SecondaryApp');
        await appToDelete.delete();
      }
    }
  }

  // Login user
  Future<User?> login({
    required String email,
    required String password,
    String? userType, // userType is optional during login, fetched from DB
  }) async {
    try {
      // Sign in with Firebase Auth
      firebase_auth.UserCredential credential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        // Fetch user type and details from Firestore
        await _fetchUserDetails(credential.user!.uid);

        // Check if fetching details failed (user might be null if permissions error or network)
        if (_currentUser == null) {
          throw Exception(
            "User profile not found in database. Please contact support.",
          );
        }

        // Optional: Verify user type matches if provided
        if (userType != null) {
          if (_currentUser!.userType != userType) {
            // Prevent login if user type doesn't match
            await logout(); // Ensure we don't leave a half-logged-in session
            throw Exception(
              "Incorrect account type. Registered as ${_currentUser!.userType}, tried logging in as $userType.",
            );
          }
        }

        return _currentUser;
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Re-throw Auth exceptions to be handled by UI
      throw Exception(e.message ?? "Authentication failed");
    } catch (e) {
      debugPrint('Login error: $e');
      throw Exception(e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Restore user session (handled by initialize/listener now)
  Future<void> restoreUserSession(User? user) async {
    // No-op or manual state update if needed, but listener usually handles this
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }
}
