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
      backgroundColor: const Color(0xFFF6F8F7),
      appBar: AppBar(
        title: Text(_isEditing ? "Update Request" : "Request Pickup"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _isEditing
                    ? "Update Pickup Request"
                    : "Request a Special Pickup",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Use this form to schedule a pickup for large or special items. "
                "Please place items at the curbside by 7 AM on your selected collection day.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Contact Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                          validator: (v) => v == null || v.isEmpty
                              ? "Phone is required"
                              : null,
                        ),
                        _inputField(
                          "Pickup Address",
                          maxLines: 2,
                          controller: _addressController,
                          validator: (v) => v == null || v.isEmpty
                              ? "Address is required"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Pickup Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              selectedDate == null
                                  ? "Preferred Pickup Date"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: TextStyle(
                                color: selectedDate == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey[400],
                            ),
                            onPressed: _isLoading ? null : _submitRequest,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
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
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "© Oikos",
                style: TextStyle(color: Colors.black45, fontSize: 12),
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
