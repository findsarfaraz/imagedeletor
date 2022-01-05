import 'package:disk_space/disk_space.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/state_manager/home_screen_state.dart';

import '../model/disk_size_model.dart';
import '../notifiers/initial_screen_notifier.dart';

abstract class DiskInfo {
  Future<DiskSizeModel> getSize();
}

class FakeDiskInfo implements DiskInfo {
  @override
  Future<DiskSizeModel> getSize() async {
    Map diskDetails = new Map();
    // var diskSize = await DiskSpace.getTotalDiskSpace;
    // var freeDisk = await DiskSpace.getFreeDiskSpace;

    diskDetails['diskSize'] = await DiskSpace.getTotalDiskSpace;
    diskDetails['freeDisk'] = await DiskSpace.getFreeDiskSpace;

    diskDetails['usedSpaced'] =
        diskDetails['diskSize'] - diskDetails['freeDisk'];
    return DiskSizeModel(diskDetails['usedSpaced'], diskDetails['diskSize']);
  }
}

final diskSizeProvider = Provider<DiskInfo>((ref) => FakeDiskInfo());

final homeScreenNotifierProvider =
    StateNotifierProvider<InitialScreenNotifier, HomeScreenState>(
  (ref) => InitialScreenNotifier(ref.watch(diskSizeProvider)),
);
