import 'package:flutter/material.dart';

class MenuItems extends StatelessWidget {
  final String name;
  const MenuItems({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width * 0.4,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Center(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
