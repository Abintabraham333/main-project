import 'package:flutter/material.dart';

class ViewSchedulePage extends StatelessWidget {
  const ViewSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Schedule"),
      ),
      body: const Center(
        child: Text("View Schedule Screen"),
      ),
    );
  }
}
