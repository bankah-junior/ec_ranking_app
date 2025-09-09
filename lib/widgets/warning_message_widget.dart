import 'package:flutter/material.dart';

class WarningMessageWidget extends StatelessWidget {
  final String text;
  final VoidCallback refreshData;
  const WarningMessageWidget({
    super.key,
    required this.text,
    required this.refreshData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "❌ $text",
            style: const TextStyle(color: Colors.red),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => refreshData,
          icon: const Icon(Icons.refresh),
          label: const Text("Retry"),
        ),
      ],
    );
  }
}
