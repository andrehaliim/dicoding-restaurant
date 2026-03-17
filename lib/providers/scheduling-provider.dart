import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class SchedulingProvider extends ChangeNotifier {
  SharedPreferences prefs;  SchedulingProvider(this.prefs) {
    _isScheduled = prefs.getBool('daily_notif') ?? false;
  }

  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  static const String taskName = "daily_restaurant_recommendation";

  Future<void> scheduledRecommendation(bool value) async {
    _isScheduled = value;
    await prefs.setBool('daily_notif', value);

    if (_isScheduled) {
      debugPrint('Scheduled recommendation turned on');
      final now = DateTime.now();
      final nineAM = DateTime(now.year, now.month, now.day, 11, 00, 0);
      final initialDelay = nineAM.isAfter(now)
          ? nineAM.difference(now)
          : nineAM.add(const Duration(days: 1)).difference(now);

      await Workmanager().registerPeriodicTask(
        taskName,
        taskName,
        frequency: const Duration(days: 1),
        initialDelay: initialDelay,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      debugPrint('Scheduled recommendation turned off');
      await Workmanager().cancelAll();
    }
    notifyListeners();
  }
}