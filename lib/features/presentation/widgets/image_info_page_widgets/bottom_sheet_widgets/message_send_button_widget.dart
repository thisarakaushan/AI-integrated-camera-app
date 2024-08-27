import 'package:flutter/material.dart';

class MessageSendButtonWidget extends StatelessWidget {
  final VoidCallback onSendMessage;

  const MessageSendButtonWidget({
    super.key,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSendMessage,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2753CF),
              Color(0xFFC882FF),
              Color(0xFF46EDFE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Transform.rotate(
          angle: -3.14 / 2,
          child: const Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
