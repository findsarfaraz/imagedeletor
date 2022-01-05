import 'dart:io' as io;
// test

//Just Push
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:riverpod/riverpod.dart';
import '../misc_function.dart' as misc_func;

class FolderListStateNotifier extends StateNotifier<List<FolderListModel>> {
  FolderListStateNotifier() : super([]);

  final func_list = misc_func.MiscFunction();

  Future<void> fetch(String path) async {
    try {
      final folder_data = await io.Directory(path).list();

      final folder_list = await folder_data.toList();
      List<FolderListModel> folderListFinal = [];
      folderListFinal = await fetchStats(folder_list);

      state = folderListFinal;
    } catch (e) {
      print("Error: fetch : ${e.toString()}");
    }
  }

  Future<List<FolderListModel>> fetchStats(
      List<io.FileSystemEntity> folder_list) async {
    List<FolderListModel> folderListFinal = [];
    try {
      io.FileStat fileStat;
      for (var f in folder_list) {
        fileStat = await f.statSync();

        folderListFinal.add(FolderListModel(
            accessDate: fileStat.accessed,
            changeDate: fileStat.changed,
            folderAbsolutePath: f.absolute.toString(),
            folderPath: f.path,
            folderFileName: func_list.get_folder_name(f.absolute.toString()),
            folderSize: fileStat.size.toDouble(),
            fileExtension: fileStat.type.toString().toLowerCase() == "file"
                ? func_list.get_file_extension(f.absolute.toString())
                : '',
            type: fileStat.type.toString(),
            modifiedDate: fileStat.modified,
            parentFolder: f.parent.toString()));
      }
    } catch (e) {
      print("Error: fetch : ${e.toString()}");
    }

    return folderListFinal;
  }

  void addNewFolder(String folderPath) async {
    try {
      final newDir = io.Directory(folderPath);
      await io.Directory(folderPath).create(recursive: true);

      final fileStat = newDir.statSync();
      final folderModel = FolderListModel(
          accessDate: fileStat.accessed,
          changeDate: fileStat.changed,
          fileExtension: fileStat.type.toString(),
          folderAbsolutePath: newDir.absolute.toString(),
          folderPath: folderPath,
          folderFileName: func_list.get_folder_name(newDir.absolute.toString()),
          folderSize: fileStat.size.toDouble(),
          modifiedDate: fileStat.modified,
          parentFolder: newDir.parent.toString(),
          type: fileStat.type.toString());

      state = [...state, folderModel];
    } catch (e) {
      print("Error: addNewFolder: ${e.toString()}");
    }
  }
}
