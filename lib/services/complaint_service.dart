import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitComplaint({
    required String complaintType,
    required DateTime dateOfIncident,
    required String location,
    required String zone,
    required String description,
  }) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("You must be logged in to lodge a complaint.");
    }

    try {
      await _firestore.collection('complaints').add({
        'userId': user.uid,
        'userEmail': user.email,
        'complaintType': complaintType,
        'dateOfIncident': Timestamp.fromDate(dateOfIncident),
        'location': location,
        'zone': zone,
        'description': description,
        'status': 'pending', // pending, resolved, dismissed
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to submit complaint: $e");
    }
  }

  // Admin: Get all complaints
  Stream<QuerySnapshot> getAllComplaints() {
    return _firestore
        .collection('complaints')
        .orderBy('dateOfIncident', descending: true)
        .snapshots();
  }

  // Admin: Update complaint status
  Future<void> updateComplaintStatus(String docId, String newStatus) async {
    try {
      await _firestore.collection('complaints').doc(docId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to update status: $e");
    }
  }
}
