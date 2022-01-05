import 'package:imagedeletor/providers/disk_info_provider.dart';
import 'package:imagedeletor/state_manager/home_screen_state.dart';
import 'package:riverpod/riverpod.dart';

class InitialScreenNotifier extends StateNotifier<HomeScreenState> {
  final DiskInfo getSizeInfo;

  InitialScreenNotifier(this.getSizeInfo) : super(HomeScreenInitial());

  Future<void> getSizeForNotifier() async {
    try {
      // throw ('This is not found');
      state = HomeScreenLoading();
      final diskModel = await getSizeInfo.getSize();
      state = HomeScreenLoaded(diskModel);
    } catch (e) {
      state = HomeScreenError(e.toString());
    }
  }
}
