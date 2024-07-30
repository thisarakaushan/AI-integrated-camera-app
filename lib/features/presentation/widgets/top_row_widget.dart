// lib/features/presentation/widgets/top_row_widget.dart

import 'package:flutter/material.dart';

class TopRowWidget extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onEditPressed;

  const TopRowWidget({
    super.key,
    required this.onMenuPressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: onMenuPressed,
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: onEditPressed,
        ),
      ],
    );
  }
}
