import 'package:flutter/material.dart';

class StartButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const StartButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final double buttonWidth =
        MediaQuery.of(context).size.width * 0.6; // 60% of screen width
    final double buttonHeight =
        MediaQuery.of(context).size.height * 0.1; // 10% of screen height

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(buttonHeight / 2), // Circular border radius
        gradient: const LinearGradient(
          colors: [
            Color(0xff2753cf),
            Color(0xffc882ff),
            Color(0xff46edfe),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xff0e235a),
            borderRadius: BorderRadius.circular(
                buttonHeight / 2), // Circular border radius
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    buttonHeight / 2), // Circular border radius
              ),
              padding: EdgeInsets.symmetric(
                horizontal: buttonWidth *
                    0.1, // Adjust padding relative to button width
                vertical: buttonHeight *
                    0.2, // Adjust padding relative to button height
              ),
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'Start',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
