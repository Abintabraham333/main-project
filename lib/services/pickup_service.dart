import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PickupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitPickupRequest({
    required String fullName,
    required String phoneNumber,
    required String address,
    required String zone,
    required String wasteType,
    required DateTime pickupDate,
  }) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("You must be logged in to request a pickup.");
    }

    try {
      await _firestore.collection('pickup_requests').add({
        'userId': user.uid,
        'userEmail': user.email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
        'zone': zone,
        'wasteType': wasteType,
        'pickupDate': Timestamp.fromDate(pickupDate),
        'status': 'pending', // pending, approved, completed, rejected
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to submit request: $e");
    }
  }

  Future<void> updatePickupRequest({
    required String docId,
    required String fullName,
    required String phoneNumber,
    required String address,
    required String zone,
    required String wasteType,
    required DateTime pickupDate,
  }) async {
    try {
      await _firestore.collection('pickup_requests').doc(docId).update({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
        'zone': zone,
        'wasteType': wasteType,
        'pickupDate': Timestamp.fromDate(pickupDate),
      });
    } catch (e) {
      throw Exception("Failed to update request: $e");
    }
  }

  // Admin: Get all pickup requests
  Stream<QuerySnapshot> getAllPickupRequests() {
    return _firestore
        .collection('pickup_requests')
        .orderBy('pickupDate', descending: true)
        .snapshots();
  }

  // Admin: Update pickup status
  Future<void> updatePickupStatus(String docId, String newStatus) async {
    try {
      await _firestore.collection('pickup_requests').doc(docId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to update status: $e");
    }
  }

  // Garbage Collector: Mark pickup as completed
  Future<void> markPickupAsCompleted(String docId) async {
    try {
      await _firestore.collection('pickup_requests').doc(docId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to mark as completed: $e");
    }
  }

  // User: Delete pickup request
  Future<void> deletePickupRequest(String docId) async {
    try {
      await _firestore.collection('pickup_requests').doc(docId).delete();
    } catch (e) {
      throw Exception("Failed to delete request: $e");
    }
  }
}
