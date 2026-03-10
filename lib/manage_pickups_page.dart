import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/pickup_service.dart';
import 'constants/app_constants.dart';

class ManagePickupsPage extends StatefulWidget {
  const ManagePickupsPage({super.key});

  @override
  State<ManagePickupsPage> createState() => _ManagePickupsPageState();
}

class _ManagePickupsPageState extends State<ManagePickupsPage> {
  final PickupService _pickupService = PickupService();

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
      case 'pending':
        return Colors.orange;
      case 'on the way':
      case 'in progress':
      case 'approved':
        return Colors.blue;
      case 'completed':
        return AppConstants.primaryGreen;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      appBar: AppBar(
        title: const Text('Manage Pickups'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4C1D95),
                Color(0xFF7C3AED),
              ], // Deep Purple to Violet
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pickupService.getAllPickupRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Color(0xFFCBD5E1),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No pickup requests found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final docId = doc.id;

              final status = data['status'] ?? 'Pending';
              final pickupDate = (data['pickupDate'] as Timestamp).toDate();
              final dateStr =
                  "${pickupDate.day}/${pickupDate.month}/${pickupDate.year}";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
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
                          Expanded(
                            child: Text(
                              'Request ID: ...${docId.substring(docId.length - 6)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFE2E8F0)),
                      ),
                      _buildInfoRow(
                        Icons.person_outline,
                        data['fullName'] ?? 'Unknown User',
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        data['address'] ?? 'No Address',
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        "Date: $dateStr",
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        Icons.delete_outline,
                        data['wasteType'] ?? 'General',
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        Icons.map_outlined,
                        "Zone: ${data['zone'] ?? 'N/A'}",
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Update Status",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF475569),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value:
                                    [
                                      'Pending',
                                      'Approved',
                                      'Completed',
                                      'Rejected',
                                    ].contains(status)
                                    ? status
                                    : null,
                                hint: const Text("Select"),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF64748B),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                items:
                                    [
                                      'Pending',
                                      'Approved',
                                      'Completed',
                                      'Rejected',
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {
                                  if (newValue != null && newValue != status) {
                                    _pickupService.updatePickupStatus(
                                      docId,
                                      newValue,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
