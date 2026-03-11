import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a notification to a specific user
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'relatedId': relatedId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to send notification: $e");
    }
  }

  // Stream of notifications for a specific user
  Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // Mark all unread notifications as read for a specific user
  Future<void> markAllAsRead(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception("Failed to mark notifications as read: $e");
    }
  }

  // Mark a specific notification as read
  Future<void> markAsRead(String docId) async {
    try {
      await _firestore.collection('notifications').doc(docId).update({
        'isRead': true,
      });
    } catch (e) {
      throw Exception("Failed to mark notification as read: $e");
    }
  }

  // Delete a specific notification
  Future<void> deleteNotification(String docId) async {
    try {
      await _firestore.collection('notifications').doc(docId).delete();
    } catch (e) {
      throw Exception("Failed to delete notification: $e");
    }
  }
}
