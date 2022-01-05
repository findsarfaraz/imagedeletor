import 'package:flutter/widgets.dart';
import 'package:imagedeletor/model/permission_model.dart';
import 'package:permission_handler/permission_handler.dart';

class DevicePermissionNotifier extends ChangeNotifier {
  late PermissionStatus permissionStatus = PermissionStatus.denied;

  Future<DevicePermission> getPermission() async {
    final status = await Permission.storage.status;

    switch (status) {
      case PermissionStatus.denied:
        {
          await Permission.storage.request();
        }
        break;
      case PermissionStatus.granted:
        {
          permissionStatus = status;
        }

        break;
      case PermissionStatus.limited:
        {}
        break;
      case PermissionStatus.restricted:
        {}
        break;
      case PermissionStatus.permanentlyDenied:
        {
          print('permanentlyDenied');
        }
        break;
    }
    return DevicePermission(permissionStatus);
  }

  Future<DevicePermission> getExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;

    switch (status) {
      case PermissionStatus.denied:
        {
          await Permission.manageExternalStorage.request();
        }
        break;
      case PermissionStatus.granted:
        {
          permissionStatus = status;
        }

        break;
      case PermissionStatus.limited:
        {}
        break;
      case PermissionStatus.restricted:
        {}
        break;
      case PermissionStatus.permanentlyDenied:
        {
          print('permanentlyDenied');
        }
        break;
    }
    return DevicePermission(permissionStatus);
  }
}
