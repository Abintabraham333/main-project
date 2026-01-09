import 'package:flutter/material.dart';

class RecyclingGuidePage extends StatelessWidget {
  const RecyclingGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recycling Guide"),
      ),
      body: const Center(
        child: Text("Recycling Guide Screen"),
      ),
    );
  }
}
