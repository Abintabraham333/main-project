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
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8B5CF6),
                Color(0xFF7C3AED),
              ], // Violet 500 to Violet 600
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            )
          : _collectorZone == null
          ? const Center(
              child: Text(
                "No zone assigned",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4C1D95),
                ), // Violet 900
              ),
            )
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
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                  );

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No past collections found.",
                      style: TextStyle(color: Color(0xFF4C1D95), fontSize: 16),
                    ),
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.purple[200],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No past collections found for your zone.",
                          style: TextStyle(
                            color: Color(0xFF4C1D95),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE9FE), // Violet 100
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.history,
                            color: Color(0xFF8B5CF6), // Violet 500
                          ),
                        ),
                        title: Text(
                          data['address'] ?? 'No address',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B), // Slate 800
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "$dateStr - ${data['wasteType'] ?? 'General'}",
                            style: const TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981), // Emerald 500
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
