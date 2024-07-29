// lib/features/presentation/widgets/top_row_widget.dart

import 'package:flutter/material.dart';

class TopRowWidget extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onEditPressed;

  const TopRowWidget({
    Key? key,
    required this.onMenuPressed,
    required this.onEditPressed,
  }) : super(key: key);

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
