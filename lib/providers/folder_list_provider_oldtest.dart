import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/file_type_filter_model.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/notifiers/folder_list_screen_notifier.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:io' as io;

final providerFilterListProvider = Provider<FileTypeFilterModel>((ref) {
  return FileTypeFilterModel("");
});

final folderListAsyncProvider = StateNotifierProvider<FolderListStateNotifier,
    AsyncValue<List<FolderListModel>>>((ref) {
  return FolderListStateNotifier(ref);
});

final folderStateProvider =
    StateProvider<AsyncValue<List<FolderListModel>>>((ref) {
  final data = ref.watch(folderListAsyncProvider);

  return data;
});

final folderListFutureProvider = FutureProvider((ref) async {
  final data = await ref.watch(folderStateProvider);
  ref.read(folderLoadingStateProvider.state).state = false;
  return data;
});

final folderLoadingStateProvider = StateProvider<bool>((ref) {
  return false;
});
