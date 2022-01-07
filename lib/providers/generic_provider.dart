import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:riverpod/riverpod.dart';

final folderPathStateProvider = StateProvider<String>((ref) {
  return 'xxx';
});

final folderPathProvider = Provider<String>((ref) {
  final data = ref.watch(folderPathStateProvider);
  ref.watch(folderListAsyncProvider.notifier).fetch(data);
  ref
      .watch(folderTrackBackStateNotifierProvider.notifier)
      .modifyFolderBackTrack(data);

  return data;
});
