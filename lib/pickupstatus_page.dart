import 'package:flutter/material.dart';
import 'constants/app_constants.dart';

// Pickup Status Model
class PickupRequest {
  final String requestId;
  final DateTime scheduledDate;
  final String location;
  final String status; // Scheduled, On the way, Completed, Cancelled
  final String wasteType;
  final String zone;
  final String collectorName;
  final String collectorPhone;
  final double estimatedWeight;
  final DateTime createdDate;
  final String notes;

  PickupRequest({
    required this.requestId,
    required this.scheduledDate,
    required this.location,
    required this.status,
    required this.wasteType,
    required this.zone,
    required this.collectorName,
    required this.collectorPhone,
    required this.estimatedWeight,
    required this.createdDate,
    required this.notes,
  });
}

class PickupStatusPage extends StatefulWidget {
  const PickupStatusPage({super.key});

  @override
  State<PickupStatusPage> createState() => _PickupStatusPageState();
}

class _PickupStatusPageState extends State<PickupStatusPage> {
  // Sample active pickup requests
  final List<PickupRequest> activePickups = [
    PickupRequest(
      requestId: 'REQ001',
      scheduledDate: DateTime(2025, 1, 23, 10, 30),
      location: '123 Main Street, Apt 4B',
      status: 'On the way',
      wasteType: 'Organic Waste',
      zone: 'Zone A',
      collectorName: 'John Smith',
      collectorPhone: '+1-555-0101',
      estimatedWeight: 20.0,
      createdDate: DateTime(2025, 1, 22, 09, 00),
      notes: 'Please ensure waste is in sealed bags',
    ),
    PickupRequest(
      requestId: 'REQ002',
      scheduledDate: DateTime(2025, 1, 24, 14, 00),
      location: '456 Oak Avenue',
      status: 'Scheduled',
      wasteType: 'Plastic & Recyclables',
      zone: 'Zone B',
      collectorName: 'Emma Johnson',
      collectorPhone: '+1-555-0102',
      estimatedWeight: 15.5,
      createdDate: DateTime(2025, 1, 22, 10, 30),
      notes: 'Separate recyclables by type',
    ),
    PickupRequest(
      requestId: 'REQ003',
      scheduledDate: DateTime(2025, 1, 22, 16, 45),
      location: '789 Pine Road',
      status: 'Completed',
      wasteType: 'Mixed Waste',
      zone: 'Zone C',
      collectorName: 'Mike Davis',
      collectorPhone: '+1-555-0103',
      estimatedWeight: 25.0,
      createdDate: DateTime(2025, 1, 20, 14, 00),
      notes: 'Pickup completed successfully',
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'on the way':
        return Colors.orange;
      case 'completed':
        return AppConstants.primaryGreen;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Icons.schedule;
      case 'on the way':
        return Icons.local_shipping;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup Status"),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: activePickups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No active pickups',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Request a pickup to see status updates here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Pickups (${activePickups.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...activePickups.map((pickup) {
                    return _buildPickupCard(pickup, context);
                  }).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildPickupCard(PickupRequest pickup, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Request ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request ID: ${pickup.requestId}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pickup.wasteType,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(pickup.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(pickup.status),
                        size: 16,
                        color: _getStatusColor(pickup.status),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pickup.status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(pickup.status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            // Location and Date
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 20, color: AppConstants.primaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pickup Location',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pickup.location,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Scheduled Date and Time
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 20, color: AppConstants.primaryGreen),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scheduled Date & Time',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pickup.scheduledDate.day}/${pickup.scheduledDate.month}/${pickup.scheduledDate.year} at ${pickup.scheduledDate.hour}:${pickup.scheduledDate.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Zone
            Row(
              children: [
                Icon(Icons.map, size: 20, color: AppConstants.primaryGreen),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Zone',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pickup.zone,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Estimated Weight
            Row(
              children: [
                Icon(Icons.balance, size: 20, color: AppConstants.primaryGreen),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Weight',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pickup.estimatedWeight} kg',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16),
            // Collector Information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Assigned Collector',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pickup.collectorName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pickup.collectorPhone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Calling ${pickup.collectorName}...',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.call, size: 18),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Notes
            if (pickup.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pickup.notes,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pickup rescheduled'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text('Reschedule'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Support ticket created'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Support'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
