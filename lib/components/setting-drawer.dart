import 'package:flutter/material.dart';
import 'package:restaurant/components/accent-color-switcher.dart';
import 'package:restaurant/components/theme-switcher.dart';


class SettingDrawer extends StatelessWidget {
  const SettingDrawer({super.key});

  @override
  Widget build(BuildContext context) {    final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return Drawer(
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Settings',
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Dark Mode'),
            trailing: const ThemeSwitcher(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "App Accent Color",
              style: textTheme.titleMedium?.copyWith(color: colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          const AccentColorSwitcher(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '@andrehaliim',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}
