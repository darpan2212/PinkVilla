import 'package:flutter/foundation.dart';

class Logger {
  static void printObj(Object obj) {
    if (!kReleaseMode) {
      print(obj);
    }
  }
}
