// lib/widgets/chat_input_widget.dart

import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  final VoidCallback onNavigateToMainPage;
  final VoidCallback onSendMessage;

  const BottomSheetWidget({
    super.key,
    required this.onNavigateToMainPage,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onNavigateToMainPage,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF051338),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2753CF),
                    Color(0xFFC882FF),
                    Color(0xFF46EDFE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF051338),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type message...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 2,
                  child: GestureDetector(
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
