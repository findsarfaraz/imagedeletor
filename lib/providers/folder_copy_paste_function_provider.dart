import 'dart:io' as io;

import 'package:hooks_riverpod/hooks_riverpod.dart';

final folderCopyStateProvider = StateProvider<io.FileSystemEntity>((ref) {
  io.FileSystemEntity fileSystemEntity = io.Directory("storage/emulated/0");
  return fileSystemEntity;
});

final folderCopyProvider = Provider((ref) {
  final folderCopyData = ref.watch(folderCopyStateProvider);
  return folderCopyData;
});
