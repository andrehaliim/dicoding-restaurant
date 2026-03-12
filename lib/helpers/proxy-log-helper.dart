import 'package:flutter/foundation.dart';
import 'package:restaurant/models/proxy-log-model.dart';

class ProxyLogger {
  static void log(ProxyLogModel log) {
    debugPrint(log.toString());
  }
}
