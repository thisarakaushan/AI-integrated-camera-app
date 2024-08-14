import 'package:flutter/material.dart';

class BuyNowButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BuyNowButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      ),
      child: Text('Buy Now', style: TextStyle(color: Colors.white)),
    );
  }
}
