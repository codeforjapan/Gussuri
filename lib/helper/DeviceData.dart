import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceData {
  DeviceData._() {
    throw AssertionError("private Constructor");
  }

  static const _storage = FlutterSecureStorage();
  static const _key = 'device_unique_id';

  // 同時呼び出しのレース条件を防ぐためFutureをキャッシュ
  static Future<String>? _cachedFuture;

  static Future<String> getDeviceUniqueId() {
    _cachedFuture ??= _resolveId();
    return _cachedFuture!;
  }

  static Future<String> _resolveId() async {
    final stored = await _storage.read(key: _key);
    if (stored != null) return stored;

    // 初回 or 移行: 既存の identifierForVendor を引き継いで Keychain に保存
    final id = await _fetchRawDeviceId();
    await _storage.write(key: _key, value: id);
    return id;
  }

  static Future<String> _fetchRawDeviceId() async {
    if (Platform.isAndroid) {
      // androidInfo.id は Build.ID（ファームウェアラベル）で端末固有値ではないため UUID を使用
      return const Uuid().v4();
    }
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      // null の場合は 'unknown' でなく UUID を生成（コレクション衝突を防ぐ）
      return iosInfo.identifierForVendor ?? const Uuid().v4();
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId ?? const Uuid().v4();
    } else if (kIsWeb) {
      final webInfo = await deviceInfo.webBrowserInfo;
      return '${webInfo.vendor ?? ''}${webInfo.userAgent ?? ''}${webInfo.hardwareConcurrency}';
    }
    return const Uuid().v4();
  }
}
