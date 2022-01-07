import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/folder_trackback_model.dart';
import 'package:imagedeletor/notifiers/fold_trackback_notifier.dart';

final folderTrackBackStateNotifierProvider =
    StateNotifierProvider<FolderTrackBackNotifier, List<FolderTrackBackModel>>(
        (ref) {
  return FolderTrackBackNotifier();
});

final folderTrackBackProvider = StateProvider((ref) {
  final data = ref.watch(folderTrackBackStateNotifierProvider);

  data.forEach((element) {
    print(element.FolderName);
  });
  return data;
});
