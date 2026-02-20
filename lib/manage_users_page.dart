import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants/app_constants.dart';

import 'add_collector_page.dart';
import 'collector_details_page.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users & Collectors'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCollectorPage()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final userType = data['userType'] ?? 'Resident';

              final isCollector = userType.toString().toLowerCase().contains(
                'collector',
              );

              return Card(
                elevation: 2,
                color: isCollector
                    ? Colors.orange.withOpacity(0.05)
                    : Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isCollector
                      ? BorderSide(color: Colors.orange.withOpacity(0.3))
                      : BorderSide.none,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getUserTypeColor(
                      userType,
                    ).withOpacity(0.2),
                    child: Icon(
                      _getUserTypeIcon(userType),
                      color: _getUserTypeColor(userType),
                    ),
                  ),
                  title: Text(
                    data['fullName'] ?? data['email'] ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "$userType ${data['assignedZone'] != null ? '(${data['assignedZone']})' : ''}",
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteUser(context, doc.id, data['fullName']);
                      } else if (value == 'view') {
                        if (isCollector) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollectorDetailsPage(
                                userData: data,
                                userId: doc.id,
                              ),
                            ),
                          );
                        } else {
                          _showUserDetails(context, data, doc.id);
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('View Details'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete User',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                  onTap: () {
                    if (isCollector) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollectorDetailsPage(
                            userData: data,
                            userId: doc.id,
                          ),
                        ),
                      );
                    } else {
                      _showUserDetails(context, data, doc.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getUserTypeColor(String type) {
    if (type.toLowerCase().contains('collector')) return Colors.orange;
    switch (type.toLowerCase()) {
      case 'admin':
        return Colors.deepPurple;
      default:
        return AppConstants.primaryGreen;
    }
  }

  IconData _getUserTypeIcon(String type) {
    if (type.toLowerCase().contains('collector')) return Icons.local_shipping;
    switch (type.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  void _showUserDetails(
    BuildContext context,
    Map<String, dynamic> data,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("User Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow(Icons.email, "Email", data['email']),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.person,
              "Full Name",
              data['fullName'] ?? 'N/A',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.phone, "Phone", data['phoneNumber'] ?? 'N/A'),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.badge, "User Type", data['userType']),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.map, "Zone", data['assignedZone'] ?? 'N/A'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(context, userId, data['fullName']);
            },
            child: const Text(
              "Delete User",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(value ?? 'N/A', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  void _deleteUser(BuildContext context, String userId, String? userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: Text(
          "Are you sure you want to delete ${userName ?? 'this user'}? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .delete();
                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User deleted successfully")),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
