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
      appBar: AppBar(
        title: const Text('Manage Pickups'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
              child: Text(
                'No pickup requests found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
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

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getStatusColor(status),
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.person,
                        data['fullName'] ?? 'Unknown User',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.location_on,
                        data['address'] ?? 'No Address',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.calendar_today, "Date: $dateStr"),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.delete,
                        data['wasteType'] ?? 'General',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.map,
                        "Zone: ${data['zone'] ?? 'N/A'}",
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Update Status: "),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
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
                        ],
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
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
