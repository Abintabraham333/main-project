import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/pickup_service.dart';

class RequestPickupPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final String? docId;

  const RequestPickupPage({super.key, this.initialData, this.docId});

  @override
  State<RequestPickupPage> createState() => _RequestPickupPageState();
}

class _RequestPickupPageState extends State<RequestPickupPage> {
  final _formKey = GlobalKey<FormState>();
  final PickupService _pickupService = PickupService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String zone = 'Zone A';
  String wasteType = 'Food Waste';
  DateTime? selectedDate;
  bool _isLoading = false;
  bool _isEditing = false; // New flag

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _isEditing = true;
      _nameController.text = widget.initialData!['fullName'] ?? '';
      _phoneController.text = widget.initialData!['phoneNumber'] ?? '';
      _addressController.text = widget.initialData!['address'] ?? '';
      zone = widget.initialData!['zone'] ?? 'Zone A';
      wasteType = widget.initialData!['wasteType'] ?? 'Food Waste';

      if (widget.initialData!['pickupDate'] != null) {
        selectedDate = (widget.initialData!['pickupDate'] as Timestamp)
            .toDate();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a pickup date"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditing && widget.docId != null) {
        await _pickupService.updatePickupRequest(
          docId: widget.docId!,
          fullName: _nameController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          zone: zone,
          wasteType: wasteType,
          pickupDate: selectedDate!,
        );
      } else {
        await _pickupService.submitPickupRequest(
          fullName: _nameController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          zone: zone,
          wasteType: wasteType,
          pickupDate: selectedDate!,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? "Pickup request updated successfully!"
                : "Pickup request submitted successfully!",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Go back after success
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll("Exception: ", "")),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
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
        title: Text(_isEditing ? "Update Request" : "Request Pickup"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F766E),
                Color(0xFF10B981),
              ], // Deep Teal to Emerald
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _isEditing ? "Update Request" : "Schedule a Pickup",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Use this form to schedule a pickup for large or special items. "
                "Please place items at the curbside by 7 AM on your selected collection day.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Contact Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _inputField(
                          "Full Name",
                          controller: _nameController,
                          validator: (v) => v == null || v.isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        _inputField(
                          "Phone Number",
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Phone is required";
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                              return "Phone number must be exactly 10 digits";
                            }
                            return null;
                          },
                        ),
                        _inputField(
                          "Pickup Address",
                          maxLines: 2,
                          controller: _addressController,
                          validator: (v) => v == null || v.isEmpty
                              ? "Address is required"
                              : null,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Pickup Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _dropdownField(
                          label: "Zone / Area",
                          value: zone,
                          items: const ['Zone A', 'Zone B', 'Zone C'],
                          onChanged: (value) {
                            setState(() {
                              zone = value!;
                            });
                          },
                        ),
                        _dropdownField(
                          label: "Type of Waste",
                          value: wasteType,
                          items: const ['Food Waste', 'Dry Waste', 'E-Waste'],
                          onChanged: (value) {
                            setState(() {
                              wasteType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate == null
                                      ? "Preferred Pickup Date"
                                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: selectedDate == null
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Color(0xFF64748B),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F766E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(
                                0xFF0F766E,
                              ).withOpacity(0.5),
                              disabledBackgroundColor: Colors.grey[400],
                            ),
                            onPressed: _isLoading ? null : _submitRequest,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _isEditing
                                        ? "Update Request"
                                        : "Submit Request",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "© Oikos",
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label, {
    int maxLines = 1,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
