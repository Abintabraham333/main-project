import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectorDetailsPage extends StatelessWidget {
  final Map<String, dynamic>
  initialData; // Used for immediate display or fallback
  final String userId;

  const CollectorDetailsPage({
    super.key,
    required Map<String, dynamic>
    userData, // Changed from this.userData to mapped parameter
    required this.userId,
  }) : initialData = userData;

  // Alias for userData to fix constructor parameter name if needed,
  // but looking at previous file, the constructor param was named userData.
  // We'll keep the constructor signature compatible.

  // NOTE: In the replacement content, I will correct the constructor to match exactly what is expected
  // but use the StreamBuilder.

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text("User not found")));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: Text(userData['fullName'] ?? 'Collector Details'),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditProfileDialog(context, userData),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userData['fullName'] ?? 'Unknown Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Zone: ${userData['assignedZone'] ?? 'Unassigned'}",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Performance Stats (Mock Data for now as per original file)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Performance Metrics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Pickups Completed',
                        '125',
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Complaints Linked',
                        '2',
                        Icons.warning,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Missed Pickups',
                        '5',
                        Icons.unpublished,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Rating',
                        '4.8/5',
                        Icons.star,
                        Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Actions
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.edit_location,
                      color: Colors.orange,
                    ),
                    title: const Text('Change Assigned Zone'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showZoneEditor(context);
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blue),
                    title: Text(userData['phoneNumber'] ?? 'No Phone'),
                    trailing: const Icon(Icons.call),
                    onTap: () {},
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email, color: Colors.purple),
                    title: Text(userData['email'] ?? ''),
                  ),
                ),
                const SizedBox(height: 30),

                // Delete Action
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteConfirmation(context),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text("Delete Collector Account"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _showZoneEditor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? newZone;
        return AlertDialog(
          title: const Text("Assign Zone"),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('zones').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );

              List<DropdownMenuItem<String>> zoneItems = snapshot.data!.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name'] as String;
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  })
                  .toList();

              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Select Zone"),
                items: zoneItems,
                onChanged: (val) => newZone = val,
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (newZone != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'assignedZone': newZone});
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    Map<String, dynamic> userData,
  ) {
    final TextEditingController nameController = TextEditingController(
      text: userData['fullName'],
    );
    final TextEditingController phoneController = TextEditingController(
      text: userData['phoneNumber'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({
                      'fullName': nameController.text.trim(),
                      'phoneNumber': phoneController.text.trim(),
                    });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully"),
                    ),
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
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete this specific Garbage Collector?\n\nThis action cannot be undone.",
          style: TextStyle(color: Colors.red),
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
                // Also optionally delete from Auth if using Admin SDK, but client SDK can't delete other users from Auth easily.
                // We will just delete the user record from Firestore for now.

                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to list
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
