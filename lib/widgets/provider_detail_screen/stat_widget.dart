import 'package:flutter/material.dart';

class StatWidget extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color color;

  const StatWidget({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: bgColor,
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

