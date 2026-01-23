import 'package:flutter/material.dart';

class ViewSchedulePage extends StatefulWidget {
  const ViewSchedulePage({super.key});

  @override
  State<ViewSchedulePage> createState() => _ViewSchedulePageState();
}

class _ViewSchedulePageState extends State<ViewSchedulePage> {
  // Sample pickup requests with status
  final List<Map<String, dynamic>> pickupRequests = [
    {
      'id': 'REQ001',
      'date': '2026-01-25',
      'time': '08:00 AM',
      'address': '123 Main Street',
      'zone': 'Zone A',
      'wasteType': 'General Waste',
      'status': 'Pending',
      'statusColor': Colors.orange,
      'icon': Icons.schedule,
    },
    {
      'id': 'REQ002',
      'date': '2026-01-24',
      'time': '10:30 AM',
      'address': '456 Oak Avenue',
      'zone': 'Zone B',
      'wasteType': 'Recyclables',
      'status': 'Completed',
      'statusColor': Colors.green,
      'icon': Icons.check_circle,
    },
    {
      'id': 'REQ003',
      'date': '2026-01-26',
      'time': '02:00 PM',
      'address': '789 Elm Street',
      'zone': 'Zone C',
      'wasteType': 'Mixed Waste',
      'status': 'In Progress',
      'statusColor': Colors.blue,
      'icon': Icons.local_shipping,
    },
    {
      'id': 'REQ004',
      'date': '2026-01-23',
      'time': '09:15 AM',
      'address': '321 Pine Road',
      'zone': 'Zone A',
      'wasteType': 'Organic Waste',
      'status': 'Cancelled',
      'statusColor': Colors.red,
      'icon': Icons.cancel,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pickup Requests Status",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Pickup Requests',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Requests: ${pickupRequests.length}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatusSummaryCard(
                      label: 'Pending',
                      count: pickupRequests
                          .where((r) => r['status'] == 'Pending')
                          .length
                          .toString(),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusSummaryCard(
                      label: 'In Progress',
                      count: pickupRequests
                          .where((r) => r['status'] == 'In Progress')
                          .length
                          .toString(),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusSummaryCard(
                      label: 'Completed',
                      count: pickupRequests
                          .where((r) => r['status'] == 'Completed')
                          .length
                          .toString(),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pickup Requests List
              const Text(
                'Request Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pickupRequests.length,
                itemBuilder: (context, index) {
                  final request = pickupRequests[index];
                  return _buildRequestCard(request);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSummaryCard({
    required String label,
    required String count,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request #${request['id']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${request['date']} • ${request['time']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    request['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: request['statusColor'],
                  avatar: Icon(
                    request['icon'],
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),

            // Location and Zone
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['address'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        request['zone'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Waste Type
            Row(
              children: [
                Icon(Icons.delete, color: Colors.orange, size: 18),
                const SizedBox(width: 8),
                Text(
                  request['wasteType'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: request['statusColor'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    request['icon'],
                    color: request['statusColor'],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getStatusDescription(request['status']),
                      style: TextStyle(
                        fontSize: 12,
                        color: request['statusColor'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 8),
                if (request['status'] == 'Pending')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'Pending':
        return 'Waiting for pickup assignment';
      case 'In Progress':
        return 'Garbage collector on the way';
      case 'Completed':
        return 'Pickup successfully completed';
      case 'Cancelled':
        return 'Request was cancelled';
      default:
        return 'Unknown status';
    }
  }
}
