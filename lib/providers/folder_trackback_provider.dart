import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/folder_trackback_model.dart';

final folderTrackBackProvider =
    ChangeNotifierProvider<FolderTrackBackData>((ref) {
  return FolderTrackBackData();
});
