import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/components/accent-color-switcher.dart';
import 'package:restaurant/components/theme-switcher.dart';
import 'package:restaurant/helpers/notification-helper.dart';
import 'package:restaurant/providers/scheduling-provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Dark Mode'),
              trailing: const ThemeSwitcher(),
            ),
            const Divider(),
            Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return ListTile(
                  title: const Text('Daily Recommendation'),
                  subtitle: const Text('Get a random restaurant at 09:00 AM'),
                  trailing: Switch.adaptive(
                    value: scheduled.isScheduled,
                      onChanged: (bool value) async {
                        if (value) {
                          final bool isGranted = await NotificationHelper().requestPermission();

                          if (isGranted) {
                            await scheduled.scheduledRecommendation(true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Notification permission is required to enable this feature"))
                            );
                          }
                        } else {
                          await scheduled.scheduledRecommendation(false);
                        }
                      }
                  ),
                );
              },
            ),
            const Divider(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "App Accent Color",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const AccentColorSwitcher(),
            Spacer(),
            Center(
              child: Text(
                '@andrehaliim',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
