import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants/app_constants.dart';

class ManageZonesPage extends StatefulWidget {
  const ManageZonesPage({super.key});

  @override
  State<ManageZonesPage> createState() => _ManageZonesPageState();
}

class _ManageZonesPageState extends State<ManageZonesPage> {
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Zones'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('zones').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAddZoneCard(),
              const SizedBox(height: 20),
              const Text(
                "Active Zones",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (docs.isEmpty)
                const Text(
                  "No zones added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ...docs.map((doc) => _buildZoneItem(doc)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddZoneCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add New Zone",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _zoneController,
              decoration: const InputDecoration(
                labelText: "Zone Name (e.g., Zone D)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description / Areas Covered",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: _addZone,
                child: const Text("Add Zone"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.map, color: Colors.deepPurple),
        title: Text(data['name'] ?? 'Unnamed Zone'),
        subtitle: Text(data['description'] ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteZone(doc.id),
        ),
      ),
    );
  }

  Future<void> _addZone() async {
    if (_zoneController.text.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('zones').add({
        'name': _zoneController.text,
        'description': _descController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _zoneController.clear();
      _descController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Zone added successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error adding zone: $e")));
      }
    }
  }

  Future<void> _deleteZone(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('zones').doc(docId).delete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error deleting zone: $e")));
      }
    }
  }
}
