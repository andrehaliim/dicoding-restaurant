import 'package:flutter/material.dart';
import 'package:restaurant/components/accent-color-switcher.dart';
import 'package:restaurant/components/theme-switcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
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
              style: textTheme.titleMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          const AccentColorSwitcher(),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '@andrehaliim',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
          ),
        ],
      ),
    );
  }
}
