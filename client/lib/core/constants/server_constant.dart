import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ServerConstant {
  static String get serverURL {
    if (kIsWeb) {
      // Web cannot use Platform; assume backend runs on localhost
      return "http://127.0.0.1:8000";
    } else if (Platform.isAndroid) {
      // Android emulator
      return "http://10.0.2.2:8000";
    } else {
      // iOS simulator / desktop
      return "http://127.0.0.1:8000";
    }
  }
}
