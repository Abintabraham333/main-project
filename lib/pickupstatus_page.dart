import 'package:flutter/material.dart';

class PickupStatusPage extends StatelessWidget {
  const PickupStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup Status"),
      ),
      body: const Center(
        child: Text("Pickup Status Screen"),
      ),
    );
  }
}
