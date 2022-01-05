import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/notifiers/permission_notifier.dart';

final devicePermissionProvider =
    ChangeNotifierProvider<DevicePermissionNotifier>((ref) {
  return DevicePermissionNotifier();
});
