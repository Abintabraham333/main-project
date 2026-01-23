import 'package:flutter/material.dart';
import 'home_page.dart';
import 'about_page.dart';
import 'help_page.dart';

class LodgeComplaintPage extends StatefulWidget {
  const LodgeComplaintPage({super.key});

  @override
  State<LodgeComplaintPage> createState() => _LodgeComplaintPageState();
}

class _LodgeComplaintPageState extends State<LodgeComplaintPage> {
  String complaintType = 'Missed Pickup';
  String zone = 'Zone A';
  DateTime selectedDate = DateTime.now();

  final TextEditingController locationController =
      TextEditingController(text: 'Address');
  final TextEditingController descriptionController = TextEditingController();

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // 🔹 Top Navigation Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                const Text(
                  'Oikos',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),

                // 🔹 Navigation buttons
                navItem('Home', () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                }),

                navItem('About Us', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                }),

                navItem('Help', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpPage()),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Lodge a Complaint',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'We are sorry for any inconvenience. Please provide detailed information below so we can address the issue promptly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 600,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Incident Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: dropdownField(
                              label: 'Nature of Complaint',
                              value: complaintType,
                              items: ['Missed Pickup', 'Delay', 'Other'],
                              onChanged: (val) {
                                setState(() => complaintType = val!);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: dateField()),
                        ],
                      ),

                      const SizedBox(height: 16),

                      textField(
                        label: 'Location of Incident',
                        controller: locationController,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      dropdownField(
                        label: 'Zone/Area',
                        value: zone,
                        items: ['Zone A', 'Zone B', 'Zone C'],
                        onChanged: (val) {
                          setState(() => zone = val!);
                        },
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Complaint Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 12),

                      textField(
                        label: 'Provide a Detailed Description',
                        controller: descriptionController,
                        maxLines: 4,
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Submit Complaint',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Navigation Item Widget
  Widget navItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 🔹 Text Field
  Widget textField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Dropdown Field
  Widget dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Date Picker Field (NO intl package needed)
  Widget dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of Incident'),
        const SizedBox(height: 6),
        InkWell(
          onTap: pickDate,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${selectedDate.day.toString().padLeft(2, '0')}/"
                  "${selectedDate.month.toString().padLeft(2, '0')}/"
                  "${selectedDate.year}",
                ),
                const Icon(Icons.calendar_today, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
