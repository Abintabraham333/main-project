import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';

class TodaysRoutePage extends StatefulWidget {
  const TodaysRoutePage({super.key});

  @override
  State<TodaysRoutePage> createState() => _TodaysRoutePageState();
}

class _TodaysRoutePageState extends State<TodaysRoutePage> {
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
      backgroundColor: const Color(0xFFFFFBEB), // Amber 50
      appBar: AppBar(
        title: const Text("Today's Route"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD97706),
                Color(0xFFF59E0B),
              ], // Amber 600 to Amber 500
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _collectorZone == null
          ? const Center(
              child: Text(
                "No zone assigned to your account.\nPlease contact admin.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF92400E),
                ), // Amber 900
              ),
            )
          : _buildPickupList(),
    );
  }

  Widget _buildPickupList() {
    // Get start and end of today
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pickup_requests')
          .where(
            'pickupDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where(
            'pickupDate',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD97706)),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "No pickups found.",
              style: TextStyle(color: Color(0xFF92400E)),
            ),
          );
        }

        // Client-side filtering
        final docs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final docZone = (data['zone'] as String?)?.toLowerCase().trim() ?? '';
          final userZone = _collectorZone?.toLowerCase().trim() ?? '';

          // Check for exact match OR if one contains the other (e.g. "Zone A" vs "A")
          return docZone == userZone ||
              docZone.endsWith(" $userZone") ||
              userZone.endsWith(" $docZone");
        }).toList();

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.amber[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "No pickups scheduled for today in $_collectorZone",
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final pickupDate = (data['pickupDate'] as Timestamp).toDate();
            // Format time manually
            final timeString =
                "${pickupDate.hour}:${pickupDate.minute.toString().padLeft(2, '0')}";
            final status = data['status'] ?? 'pending';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7), // Amber 100
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data['wasteType'] ?? 'Unknown',
                            style: const TextStyle(
                              color: Color(0xFFD97706), // Amber 600
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: status == 'completed'
                                ? const Color(0xFFD1FAE5) // Emerald 100
                                : const Color(0xFFDBEAFE), // Blue 100
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: status == 'completed'
                                  ? const Color(0xFF059669) // Emerald 600
                                  : const Color(0xFF2563EB), // Blue 600
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFFB45309), // Amber 700
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            data['address'] ?? 'No address',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B), // Slate 800
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          timeString,
                          style: const TextStyle(
                            color: Color(0xFF475569), // Slate 600
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          data['fullName'] ?? 'Unknown User',
                          style: const TextStyle(color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          data['phoneNumber'] ?? 'No phone',
                          style: const TextStyle(color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
