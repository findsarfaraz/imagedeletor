import 'dart:io' as io;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:riverpod/riverpod.dart';
import '../misc_function.dart' as misc_func;

class FolderListStateNotifier extends StateNotifier<List<FolderListModel>> {
  FolderListStateNotifier() : super([]);

  final func_list = misc_func.MiscFunction();

  Future<void> fetch(String path) async {
    print("Started State Update ${DateTime.now()}");

    try {
      final folder_data = await io.Directory(path).list();

      // final folder_list = await folder_data.toList();
      List<FolderListModel> folderListFinal = [];
      // folderListFinal = await fetchStats(folder_list);

      await for (var folder in folder_data)
        folderListFinal.add(FolderListModel(
            accessDate: folder.statSync().accessed,
            changeDate: folder.statSync().changed,
            folderAbsolutePath: folder.absolute.toString(),
            folderPath: folder.path,
            folderFileName: func_list.get_folder_name(folder.path.toString()),
            folderSize: folder.statSync().size.toDouble(),
            fileExtension:
                folder.statSync().type.toString().toLowerCase() == "file"
                    ? func_list.get_file_extension(folder.path.toString())
                    : '',
            type: folder.statSync().type.toString(),
            modifiedDate: folder.statSync().modified,
            parentFolder: folder.parent.toString()));

      state = folderListFinal;
    } catch (e) {
      print("Error: fetch : ${e.toString()}");
    }
    print("Ended State Update ${DateTime.now()}");
  }

  // Future<List<FolderListModel>> fetchStats(
  //     List<io.FileSystemEntity> folder_list) async {
  //   List<FolderListModel> folderListFinal = [];
  //   try {
  //     io.FileStat fileStat;
  //     for (var f in folder_list) {
  //       fileStat = await f.statSync();

  //       folderListFinal.add(FolderListModel(
  //           accessDate: fileStat.accessed,
  //           changeDate: fileStat.changed,
  //           folderAbsolutePath: f.absolute.toString(),
  //           folderPath: f.path,
  //           folderFileName: func_list.get_folder_name(f.path.toString()),
  //           folderSize: fileStat.size.toDouble(),
  //           fileExtension: fileStat.type.toString().toLowerCase() == "file"
  //               ? func_list.get_file_extension(f.path.toString())
  //               : '',
  //           type: fileStat.type.toString(),
  //           modifiedDate: fileStat.modified,
  //           parentFolder: f.parent.toString()));
  //     }
  //   } catch (e) {
  //     print("Error: fetch : ${e.toString()}");
  //   }

  //   return folderListFinal;
  // }

  void addNewFolder(String folderPath) async {
    try {
      final newDir = io.Directory(folderPath);
      await io.File(folderPath).create(recursive: true);

      final fileStat = newDir.statSync();
      final folderModel = FolderListModel(
          accessDate: fileStat.accessed,
          changeDate: fileStat.changed,
          fileExtension: fileStat.type.toString(),
          folderAbsolutePath: newDir.absolute.toString(),
          folderPath: folderPath,
          folderFileName: func_list.get_folder_name(newDir.path.toString()),
          folderSize: fileStat.size.toDouble(),
          modifiedDate: fileStat.modified,
          parentFolder: newDir.parent.toString(),
          type: fileStat.type.toString());

      state = [...state, folderModel];
    } catch (e) {
      print("Error: addNewFolder: ${e.toString()}");
    }
  }

  void addNewFile(String filePath) async {
    try {
      final newFile = io.File(filePath);
      await io.File(filePath).create(recursive: true);

      final fileStat = newFile.statSync();
      final folderModel = FolderListModel(
          accessDate: fileStat.accessed,
          changeDate: fileStat.changed,
          fileExtension: fileStat.type.toString(),
          folderAbsolutePath: newFile.absolute.toString(),
          folderPath: filePath,
          folderFileName: func_list.get_folder_name(newFile.path.toString()),
          folderSize: fileStat.size.toDouble(),
          modifiedDate: fileStat.modified,
          parentFolder: newFile.parent.toString(),
          type: fileStat.type.toString());

      state = [...state, folderModel];
    } catch (e) {
      print("Error: addNewFile: ${e.toString()}");
    }
  }
}
