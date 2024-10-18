import 'package:flutter/material.dart';

class UserPrompt extends StatelessWidget {
  final bool isPrompt;
  final String message;
  final String date;

  const UserPrompt({
    Key? key,
    required this.isPrompt,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment:
            isPrompt ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isPrompt ? Colors.orange[300] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
