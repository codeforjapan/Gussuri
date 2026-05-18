import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceData {
  DeviceData._() {
    throw AssertionError("private Constructor");
  } // private constructor

  static Future<String> getDeviceUniqueId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      // v12: androidInfo.id is non-nullable String
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      // v12: identifierForVendor is nullable String?
      return iosInfo.identifierForVendor ?? 'unknown';
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfo.linuxInfo;
      // v12: machineId is nullable String?
      return linuxInfo.machineId ?? 'unknown';
    } else if (kIsWeb) {
      final webInfo = await deviceInfo.webBrowserInfo;
      // v12: vendor and userAgent are nullable String?
      return '${webInfo.vendor ?? ''}${webInfo.userAgent ?? ''}${webInfo.hardwareConcurrency}';
    }
    return 'unknown';
  }
}
