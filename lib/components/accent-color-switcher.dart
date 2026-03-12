import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme-provider.dart';

class AccentColorSwitcher extends StatelessWidget {
  const AccentColorSwitcher({super.key});

  final List<Color> colors = const [
    Colors.blueGrey,
    Colors.deepPurple,Colors.indigo,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          final isSelected = themeProvider.seedColor == color;

          return GestureDetector(
            onTap: () => themeProvider.setSeedColor(color),
            child: Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                    : null,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                  : null,
            ),
          );
        },
      ),
    );
  }
}