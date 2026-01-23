import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal();

  // In-memory storage of registered users
  List<User> _registeredUsers = [];
  
  // Current logged-in user
  User? _currentUser;

  // Getters
  List<User> get registeredUsers => _registeredUsers;
  User? get currentUser => _currentUser;

  // Initialize auth service and load saved users
  Future<void> initialize() async {
    await _loadUsersFromStorage();
    await _loadCurrentUserSession();
  }

  // Load users from SharedPreferences
  Future<void> _loadUsersFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('registered_users') ?? [];
      
      _registeredUsers = usersJson
          .map((userString) => User.fromJson(jsonDecode(userString)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      print('Error loading users from storage: $e');
    }
  }

  // Load current user session from SharedPreferences
  Future<void> _loadCurrentUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      if (userJson != null) {
        _currentUser = User.fromJson(jsonDecode(userJson));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading current user session: $e');
    }
  }

  // Save users to SharedPreferences
  Future<void> _saveUsersToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = _registeredUsers
          .map((user) => jsonEncode(user.toJson()))
          .toList();
      
      await prefs.setStringList('registered_users', usersJson);
    } catch (e) {
      print('Error saving users to storage: $e');
    }
  }

  // Save current user session to SharedPreferences
  Future<void> _saveCurrentUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_currentUser != null) {
        await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
      } else {
        await prefs.remove('current_user');
      }
    } catch (e) {
      print('Error saving current user session: $e');
    }
  }

  // Sign up a new user
  Future<bool> signUp({
    required String email,
    required String password,
    required String userType,
  }) async {
    // Check if email already exists
    if (_registeredUsers.any((user) => user.email == email)) {
      return false; // User already exists
    }

    // Create new user
    final newUser = User(
      email: email,
      password: password,
      userType: userType,
    );

    _registeredUsers.add(newUser);
    
    // Save to storage
    await _saveUsersToStorage();
    
    notifyListeners();
    return true; // Sign up successful
  }

  // Login user
  Future<User?> login({
    required String email,
    required String password,
    required String userType,
  }) async {
    // Find user with matching credentials
    try {
      final user = _registeredUsers.firstWhere(
        (user) =>
            user.email == email &&
            user.password == password &&
            user.userType == userType,
      );
      _currentUser = user;
      
      // Save current user session
      await _saveCurrentUserSession();
      
      notifyListeners();
      return user;
    } catch (e) {
      return null; // User not found or credentials don't match
    }
  }

  // Check if email is registered
  bool isEmailRegistered(String email) {
    return _registeredUsers.any((user) => user.email == email);
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    await _saveCurrentUserSession();
    notifyListeners();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _currentUser != null;
  }

  // Restore user session
  Future<void> restoreUserSession(User? user) async {
    _currentUser = user;
    if (user != null) {
      await _saveCurrentUserSession();
    }
    notifyListeners();
  }

  // Clear all users (for testing)
  void clearAllUsers() {
    _registeredUsers.clear();
    _currentUser = null;
    notifyListeners();
  }
}
