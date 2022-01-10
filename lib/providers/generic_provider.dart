import 'package:imagedeletor/notifiers/folder_path_state_notifier.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:riverpod/riverpod.dart';

final folderPathStateNotifierProvider =
    StateNotifierProvider<FolderPath, String>((ref) {
  return FolderPath();
});

final folderPathStateProvider = StateProvider<String>((ref) {
  final data = ref.watch(folderPathStateNotifierProvider);

  ref.watch(folderListAsyncProvider.notifier).fetch(data);

  ref
      .watch(folderTrackBackStateNotifierProvider.notifier)
      .modifyFolderBackTrack(data);

  return data;
});

final folderPathProvider = Provider<String>((ref) {
  final data = ref.watch(folderPathStateProvider);
  return data;
});
