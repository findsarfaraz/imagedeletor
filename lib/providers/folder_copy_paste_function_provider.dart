import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io' as io;
import 'package:imagedeletor/model/folder_copy_model.dart';

final folderCopyStateProvider = StateProvider<io.FileSystemEntity>((ref) {
  io.FileSystemEntity fileSystemEntity = io.Directory("storage/emulated/0");
  return fileSystemEntity;
});

final folderCopyProvider = Provider((ref) {
  final folderCopyData = ref.watch(folderCopyStateProvider);
  return folderCopyData;
});
