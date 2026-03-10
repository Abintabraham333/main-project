import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';

class CollectorHistoryPage extends StatefulWidget {
  const CollectorHistoryPage({super.key});

  @override
  State<CollectorHistoryPage> createState() => _CollectorHistoryPageState();
}

class _CollectorHistoryPageState extends State<CollectorHistoryPage> {
  final AuthService _authService = AuthService();
  String? _collectorZone;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollectorData();
  }

  Future<void> _loadCollectorData() async {
    final user = _authService.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          _collectorZone = user.assignedZone;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _collectorZone == null
          ? const Center(child: Text("No zone assigned"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pickup_requests')
                  .where('status', isEqualTo: 'completed')
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text("Error: ${snapshot.error}"));
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No past collections found."),
                  );
                }

                // Filter by zone
                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final docZone =
                      (data['zone'] as String?)?.toLowerCase().trim() ?? '';
                  final userZone = _collectorZone?.toLowerCase().trim() ?? '';
                  return docZone == userZone ||
                      docZone.endsWith(" $userZone") ||
                      userZone.endsWith(" $docZone");
                }).toList();

                // Sort the filtered docs locally instead of using orderBy in Firestore
                docs.sort((a, b) {
                  final dataA = a.data() as Map<String, dynamic>;
                  final dataB = b.data() as Map<String, dynamic>;
                  final dateA =
                      (dataA['pickupDate'] as Timestamp?)?.toDate() ??
                      DateTime(2000);
                  final dateB =
                      (dataB['pickupDate'] as Timestamp?)?.toDate() ??
                      DateTime(2000);
                  return dateB.compareTo(dateA); // Descending order
                });

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No past collections found for your zone."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final date = (data['pickupDate'] as Timestamp?)?.toDate();
                    final dateStr = date != null
                        ? "${date.day}/${date.month}/${date.year}"
                        : 'Unknown Date';

                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.history,
                          color: Colors.purple,
                        ),
                        title: Text(data['address'] ?? 'No address'),
                        subtitle: Text(
                          "$dateStr - ${data['wasteType'] ?? 'General'}",
                        ),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
