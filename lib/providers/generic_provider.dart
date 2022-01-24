import 'package:imagedeletor/notifiers/folder_path_state_notifier.dart';
import 'package:riverpod/riverpod.dart';

final folderPathStateNotifierProvider =
    StateNotifierProvider<FolderPath, String>((ref) {
  return FolderPath(ref);
});

final folderPathStateProvider = StateProvider<String>((ref) {
  final data = ref.watch(folderPathStateNotifierProvider);
  return data;
});

final folderPathProvider = Provider<String>((ref) {
  final data = ref.watch(folderPathStateProvider);
  return data;
});
