import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class CollectorProfilePage extends StatefulWidget {
  const CollectorProfilePage({super.key});

  @override
  State<CollectorProfilePage> createState() => _CollectorProfilePageState();
}

class _CollectorProfilePageState extends State<CollectorProfilePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String? _fullName;
  String? _email;
  String? _zone;
  String? _phone;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = _authService.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          _fullName = user.fullName;
          _email = user.email;
          _zone = user.assignedZone;
          _phone = user.phoneNumber;
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
        title: const Text('My Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _fullName ?? 'Unknown Collector',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Garbage Collector',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.email,
                            'Email',
                            _email ?? 'Not provided',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.phone,
                            'Phone',
                            _phone ?? 'Not provided',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.map,
                            'Assigned Zone',
                            _zone ?? 'Not assigned',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
