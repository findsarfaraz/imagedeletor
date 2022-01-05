class DevicePermission {
  var storagePermission;

  DevicePermission(storagePermission);

  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DevicePermission && o.storagePermission == storagePermission;
  }

  @override
  int get hashCode => storagePermission.hashCode;
}
