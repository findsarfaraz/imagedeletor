import 'dart:io' as io;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/Theme/apptheme.dart';
import 'package:imagedeletor/model/app_exception_model.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/providers/app_exception_provider.dart';
import 'package:imagedeletor/providers/folder_copy_paste_function_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../misc_function.dart' as misc_func;
import 'package:path/path.dart' as path;

class FolderListStateNotifier extends StateNotifier<List<FolderListModel>> {
  FolderListStateNotifier(this.ref) : super([]);

  final Ref ref;

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

  void deleteFileFolder(String filePath, String type) async {
    try {
      final folderList = state;
      final delFileSystemEntity =
          folderList.where((element) => element.folderPath == filePath).first;
      if (type.toLowerCase() == "file") {
        io.File(delFileSystemEntity.folderPath).delete();
      } else if (type.toLowerCase() == "directory") {
        io.Directory(delFileSystemEntity.folderPath).delete(recursive: true);
        print("delete ran");
      }

      folderList.removeAt(state.indexOf(delFileSystemEntity));

      state = [...folderList];
    } catch (e) {
      print("Error: addNewFile: ${e.toString()}");
    }
  }

  void pasteFileFolder(
      io.FileSystemEntity fileSystemEntity, String newPath) async {
    final folderfileName = func_list.get_folder_name(fileSystemEntity.path);

    final type = fileSystemEntity.statSync().type;

    try {
      if (type.toString() == "file") {
        io.File curFile = io.File(fileSystemEntity.path);

        if (!io.File("${newPath}/${folderfileName}").existsSync()) {
          curFile.copy("${newPath}/${folderfileName}");
          io.FileSystemEntity newFile = io.File("${newPath}/${folderfileName}");
          FolderListModel fileListModel = getFolderListModel(newFile);
          state = [...state, fileListModel];
          ref.read(folderCopyStateProvider.state).state =
              io.Directory("storage/emulated/0");
        } else {
          curFile.copy("${newPath}/${folderfileName}_copy");
          ref.read(appMsgProvider.state).state = "File Already Exists";
          ref.read(folderCopyStateProvider.state).state =
              io.Directory("storage/emulated/0");
        }
      } else {
        io.Directory source = io.Directory(fileSystemEntity.path);
        io.Directory target = io.Directory("${newPath}/${folderfileName}");
        await copyDirectory(source, target);
        io.FileSystemEntity newDirectory =
            io.File("${newPath}/${folderfileName}");
        FolderListModel fileListModel = getFolderListModel(newDirectory);
        state = [...state, fileListModel];
      }
    } catch (e) {
      print("ERROR ${e.toString()}");
    }
  }

  Future<void> copyDirectory(
      io.Directory source, io.Directory destination) async {
    source.listSync(recursive: false).forEach((entity) {
      if (entity is io.Directory) {
        var newDirectory = io.Directory(
            path.join(destination.absolute.path, path.basename(entity.path)));
        newDirectory.createSync();

        copyDirectory(entity.absolute, newDirectory);
      } else if (entity is io.File) {
        entity
            .copySync(path.join(destination.path, path.basename(entity.path)));
      }
    });
  }

  FolderListModel getFolderListModel(io.FileSystemEntity fileSystemEntity) {
    return FolderListModel(
        folderFileName: func_list.get_folder_name(fileSystemEntity.path),
        folderPath: fileSystemEntity.path,
        folderAbsolutePath: fileSystemEntity.absolute.toString(),
        folderSize: fileSystemEntity.statSync().size.toDouble(),
        type: fileSystemEntity.statSync().type.toString(),
        changeDate: fileSystemEntity.statSync().changed,
        accessDate: fileSystemEntity.statSync().accessed,
        modifiedDate: fileSystemEntity.statSync().modified,
        fileExtension: func_list.get_file_extension(fileSystemEntity.path),
        parentFolder: fileSystemEntity.parent.toString());
  }
}
