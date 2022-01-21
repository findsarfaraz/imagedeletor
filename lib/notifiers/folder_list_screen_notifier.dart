import 'dart:io' as io;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/Theme/apptheme.dart';
import 'package:imagedeletor/model/app_exception_model.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/providers/app_exception_provider.dart';
import 'package:imagedeletor/providers/folder_copy_paste_function_provider.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../misc_function.dart' as misc_func;
import 'package:path/path.dart' as path;

class FolderListStateNotifier
    extends StateNotifier<AsyncValue<List<FolderListModel>>> {
  FolderListStateNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchState();
  }

  final Ref ref;
  final func_list = misc_func.MiscFunction();

  Future fetchState() async {
    return state;
  }

  Future<void> fetch(path) async {
    try {
      state = AsyncValue.loading();

      final folder_data = await io.Directory(path).list();
      List<FolderListModel> folderListFinal = [];

      await folder_data.forEach((element) {
        folderListFinal.add(getFolderListModel(element));
      });

      final folderListCleanData = folderListFinal.where((element) {
        return (element.folderFileName.substring(0, 1) != ".");
      }).toList();

      state = AsyncValue.data(folderListCleanData);
    } on AppExceptionModel catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> addNewFolder(String folderPath) async {
    try {
      final currentState = state;

      final newDir = io.Directory(folderPath);
      await io.Directory(folderPath).create(recursive: false);

      final folderModel = getFolderListModel(newDir);

      final newState =
          currentState.whenData((value) => [...value, folderModel]);

      state = newState.whenData((value) => [...value]);
    } on AppExceptionModel catch (e) {
      state = AsyncValue.error(e);
      ref.read(appExceptionProvider.state).state = e;
    }
  }

  Future<void> addNewFile(String filePath) async {
    try {
      final currentState = state;
      final newFile = io.File(filePath);
      await io.File(filePath).create(recursive: true);

      final folderModel = getFolderListModel(newFile);

      AsyncValue<List<FolderListModel>> newState =
          currentState.whenData((folderList) => [...folderList, folderModel]);

      newState.whenData((value) => value.forEach((element) {
            print(element.folderFileName);
          }));

      state = newState.whenData((value) => [...value]);
    } on AppExceptionModel catch (e) {
      state = AsyncValue.error(e);
      ref.read(appExceptionProvider.state).state = e;
    }
  }

  Future<void> deleteFileFolder(String filePath, String type) async {
    // String fileFolderPath;
    try {
      final folderList = state;

      final delFileSystemEntity = folderList
          .whenData((value) =>
              value.where((element) => element.folderPath == filePath).first)
          .value;

      // final delFileSystemEntity =
      //     folderList.where((element) => element.folderPath == filePath).first;
      if (type.toLowerCase() == "file") {
        io.File((delFileSystemEntity?.folderPath)!).delete();
      } else if (type.toLowerCase() == "directory") {
        io.Directory((delFileSystemEntity?.folderPath)!)
            .delete(recursive: true);
      }

      folderList.whenData(
          (value) => value.removeAt(value.indexOf(delFileSystemEntity!)));

      state = folderList.whenData((value) => [...value]);
    } on AppExceptionModel catch (e) {
      state = AsyncValue.error(e);
      ref.read(appExceptionProvider.state).state = e;
    }
  }

  void pasteFileFolder(
      io.FileSystemEntity fileSystemEntity, String newPath) async {
    try {
      final currentState = state;

      final folderfileName = func_list.get_folder_name(fileSystemEntity.path);

      final type = fileSystemEntity.statSync().type;

      final newfolderFileName =
          getCopyFileName(folderfileName, type.toString(), newPath);

      if (type.toString() == "file") {
        io.File curFile = io.File(fileSystemEntity.path);
        curFile.copy("${newPath}/${newfolderFileName}");
        io.FileSystemEntity newFile =
            io.File("${newPath}/${newfolderFileName}");
        FolderListModel fileListModel = getFolderListModel(newFile);
        state = state.whenData((value) => [...value, fileListModel]);
      } else {
        io.Directory source = io.Directory(fileSystemEntity.path);
        io.Directory target = io.Directory("${newPath}/${newfolderFileName}");

        await copyDirectory(source, target);
        io.FileSystemEntity newDirectory =
            io.Directory("${newPath}/${newfolderFileName}");

        FolderListModel fileListModel = getFolderListModel(newDirectory);

        state = state.whenData((value) => [...value, fileListModel]);
      }
    } on AppExceptionModel catch (e) {
      state = AsyncValue.error(e);
      ref.read(appExceptionProvider.state).state = e;
    }
  }

  Future<void> copyDirectory(
      io.Directory source, io.Directory destination) async {
    destination.createSync();
    try {
      source.listSync(recursive: false).forEach((entity) {
        if (entity is io.Directory) {
          var newDirectory = io.Directory(
              path.join(destination.absolute.path, path.basename(entity.path)));
          newDirectory.createSync();

          copyDirectory(entity.absolute, newDirectory);
        } else if (entity is io.File) {
          entity.copySync(
              path.join(destination.path, path.basename(entity.path)));
        }
      });
    } on AppExceptionModel catch (e) {
      state = AsyncValue.error(e);
      ref.read(appExceptionProvider.state).state = e;
    }
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

  String getCopyFileName(String existingFileName, String type, String path) {
    String tryFileName = existingFileName;
    String newFileName = existingFileName;
    int counter = 0;
    if (type == "file") {
      io.FileSystemEntity fileSystemEntity = io.File("${path}/${tryFileName}");
      while (io.File("${path}/${tryFileName}").existsSync()) {
        final fileSplit = existingFileName.split(".");

        final String number =
            counter == 0 ? "_Copy" : "_Copy${counter.toString()}";
        newFileName = "${fileSplit[0]}$number.${fileSplit[1]}";

        if (io.File("${path}/${newFileName}").existsSync()) {
          counter++;
          tryFileName = newFileName;
        } else {
          tryFileName = newFileName;
          break;
        }
      }
    } else {
      io.FileSystemEntity fileSystemEntity =
          io.Directory("${path}/${tryFileName}");

      while (io.Directory("${path}/${tryFileName}").existsSync()) {
        final fileSplit = existingFileName.split(".");

        final String number =
            counter == 0 ? "_Copy" : "_Copy${counter.toString()}";
        newFileName = "${existingFileName}$number";

        if (io.Directory("${path}/${newFileName}").existsSync()) {
          counter++;
          tryFileName = newFileName;
        } else {
          tryFileName = newFileName;
          break;
        }
      }
    }

    return newFileName;
  }
}
