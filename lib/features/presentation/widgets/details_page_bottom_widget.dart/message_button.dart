import 'package:flutter/material.dart';

class MessageButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const MessageButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35, // Adjust width as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            color: Colors.black,
            size: 20, // Adjust icon size if needed
          ),
          SizedBox(height: 4), // Space between the image and text
          Text(
            'Message',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10, // Adjust font size if needed
            ),
          ),
        ],
      ),
    );
  }
}
