import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';

class FolderPath extends StateNotifier<String> {
  FolderPath(this.ref) : super("");

  final Ref ref;

  Future<void> updatePath(String path) async {
    ref
        .watch(folderTrackBackStateNotifierProvider.notifier)
        .modifyFolderBackTrack(path);

    ref.watch(folderListAsyncProvider.notifier).fetch(path);

    state = path;
  }
}
