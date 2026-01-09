import 'package:flutter/material.dart';

class RequestPickupPage extends StatelessWidget {
  const RequestPickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Pickup"),
      ),
      body: const Center(
        child: Text("Request Pickup Screen"),
      ),
    );
  }
}
