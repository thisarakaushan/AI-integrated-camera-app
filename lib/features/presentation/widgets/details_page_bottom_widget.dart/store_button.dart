import 'package:flutter/material.dart';

class StoreButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const StoreButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50, // Adjust width as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.store,
            color: Colors.black,
            size: 20, // Adjust icon size if needed
          ),
          SizedBox(height: 4), // Space between the image and text
          Text(
            'Store',
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
