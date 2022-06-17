import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/notifiers/folder_list_screen_notifier.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';

final folderCopyStateProvider = StateProvider<io.FileSystemEntity>((ref) {
  io.FileSystemEntity fileSystemEntity = io.Directory("storage/emulated/0");
  return fileSystemEntity;
});

final folderCopyProvider = Provider((ref) {
  final folderCopyData = ref.watch(folderCopyStateProvider);
  return folderCopyData;
});

final folderCopyDeleteStatus = StateProvider<Map<String, String>>((ref) {
  return {"foldername": "", "complete_percentage": ""};
});

final folderCopyStatusFuture = FutureProvider((ref) async {
  final data = ref.watch(folderCopyDeleteStatus);

  return data;
});

final isDeleteStatusProvider = StateProvider<bool>((ref) {
  return false;
});
