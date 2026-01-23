
import 'package:flutter/material.dart';
import 'constants/app_constants.dart';

// Pickup Model
class PickupRecord {
  final String id;
  final DateTime pickupDate;
  final String location;
  final double wasteWeight;
  final String status;
  final String wasteType;
  final String notes;

  PickupRecord({
    required this.id,
    required this.pickupDate,
    required this.location,
    required this.wasteWeight,
    required this.status,
    required this.wasteType,
    required this.notes,
  });
}

class PickupHistoryPage extends StatefulWidget {
  const PickupHistoryPage({super.key});

  @override
  State<PickupHistoryPage> createState() => _PickupHistoryPageState();
}

class _PickupHistoryPageState extends State<PickupHistoryPage> {
  // Sample pickup history data
  final List<PickupRecord> pickupHistory = [
    PickupRecord(
      id: 'PU001',
      pickupDate: DateTime(2025, 1, 20, 10, 30),
      location: '123 Main Street, Apt 4B',
      wasteWeight: 15.5,
      status: 'Completed',
      wasteType: 'Organic Waste',
      notes: 'Pickup completed successfully',
    ),
    PickupRecord(
      id: 'PU002',
      pickupDate: DateTime(2025, 1, 18, 14, 15),
      location: '456 Oak Avenue',
      wasteWeight: 22.0,
      status: 'Completed',
      wasteType: 'Plastic & Recyclables',
      notes: 'Sorted and ready for recycling',
    ),
    PickupRecord(
      id: 'PU003',
      pickupDate: DateTime(2025, 1, 15, 09, 00),
      location: '789 Pine Road',
      wasteWeight: 18.3,
      status: 'Completed',
      wasteType: 'Mixed Waste',
      notes: 'Standard pickup',
    ),
    PickupRecord(
      id: 'PU004',
      pickupDate: DateTime(2025, 1, 12, 11, 45),
      location: '321 Elm Street',
      wasteWeight: 25.7,
      status: 'Pending',
      wasteType: 'Organic Waste',
      notes: 'Scheduled for collection',
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppConstants.primaryGreen;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup History"),
        backgroundColor: AppConstants.primaryGreen,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pickupHistory.isEmpty
            ? const Center(
                child: Text(
                  'No pickup history available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: pickupHistory.length,
                itemBuilder: (context, index) {
                  final pickup = pickupHistory[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with ID and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pickup ID: ${pickup.id}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(pickup.status)
                                      .withOpacity(0.2),
                                  border: Border.all(
                                    color: _getStatusColor(pickup.status),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  pickup.status,
                                  style: TextStyle(
                                    color: _getStatusColor(pickup.status),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Date and Time
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                '${pickup.pickupDate.toLocal().toString().split('.')[0]}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Location
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  pickup.location,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Waste Type
                          Row(
                            children: [
                              const Icon(Icons.category,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                pickup.wasteType,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Weight and Notes Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.scale,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${pickup.wasteWeight} kg',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  pickup.notes,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
