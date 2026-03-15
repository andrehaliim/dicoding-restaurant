import 'package:flutter/material.dart';
import 'package:restaurant/helpers/notification-helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulingProvider extends ChangeNotifier {
  static const String _schedulingKey = 'scheduled_notification';
  final SharedPreferences _prefs;
  bool _isScheduled;

  SchedulingProvider(this._prefs)
    : _isScheduled = _prefs.getBool(_schedulingKey) ?? false;

  bool get isScheduled => _isScheduled;

  Future<void> setScheduled(bool value) async {
    if (value) {
      final isPermissionGranted = await NotificationHelper()
          .requestPermission();
      if (!isPermissionGranted) {
        _isScheduled = false;
        notifyListeners();
        debugPrint('Notification permission denied');
        return;
      }
    }

    _isScheduled = value;
    notifyListeners();
    await _prefs.setBool(_schedulingKey, value);

    if (value) {
      debugPrint('Scheduled Notification Activated at 11:00 AM');
      await NotificationHelper().scheduleDailyNotification(
        id: 1,
        title: 'Lunch Reminder',
        body: "It's 11 AM, time to have lunch!",
        hour: 11,
        minute: 00,
      );
    } else {
      debugPrint('Scheduled Notification Deactivated');
      await NotificationHelper().cancelNotification(1);
    }
  }
}
