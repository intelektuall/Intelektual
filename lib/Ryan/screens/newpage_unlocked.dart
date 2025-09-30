import 'package:flutter/material.dart';

class NewPageUnlocked extends StatelessWidget {
  const NewPageUnlocked({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
      ),
      body: const Center(
        child: Text(
          "Mobile App is Under Maintanance",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
