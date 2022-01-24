import 'dart:io' as io;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/app_exception_model.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/providers/app_exception_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod/riverpod.dart';

import '../misc_function.dart' as misc_func;

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

      await folder_data.forEach((element) async {
        final fileListModel = await getFolderListModel(element);
        folderListFinal.add(fileListModel);
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

      final folderModel = await getFolderListModel(newDir);

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

      final folderModel = await getFolderListModel(newFile);

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

  Future<void> pasteFileFolder(
      io.FileSystemEntity fileSystemEntity, String newPath) async {
    try {
      final currentState = state;

      final folderfileName = await p.basename(fileSystemEntity.path);

      final stats = await fileSystemEntity.statSync();

      final type = stats.type.toString();

      final newfolderFileName =
          await getCopyFileName(folderfileName, type.toString(), newPath);

      if (type == "file") {
        io.File curFile = io.File(fileSystemEntity.path);
        await curFile.copy("${newPath}/${newfolderFileName}");

        io.FileSystemEntity newFile =
            await io.File("${newPath}/${newfolderFileName}");

        FolderListModel fileListModel = await getFolderListModel(newFile);

        state = state.whenData((value) => [...value, fileListModel]);
        ref.read(appMsgProvider.state).state =
            "File ${newfolderFileName} Successfully Copied";
      } else {
        io.Directory source = io.Directory(fileSystemEntity.path);
        io.Directory target = io.Directory("${newPath}/${newfolderFileName}");

        await copyDirectory(source, target);
        io.FileSystemEntity newDirectory =
            io.Directory("${newPath}/${newfolderFileName}");

        FolderListModel fileListModel = await getFolderListModel(newDirectory);

        state = state.whenData((value) => [...value, fileListModel]);

        ref.read(appMsgProvider.state).state =
            "File ${newfolderFileName} Successfully Copied";
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
              p.join(destination.absolute.path, p.basename(entity.path)));
          newDirectory.createSync();

          copyDirectory(entity.absolute, newDirectory);
        } else if (entity is io.File) {
          entity.copySync(p.join(destination.path, p.basename(entity.path)));
        }
      });
    } on AppExceptionModel catch (e) {
      state = AsyncValue.error(e);
      ref.read(appExceptionProvider.state).state = e;
    }
  }

  Future<FolderListModel> getFolderListModel(
      io.FileSystemEntity fileSystemEntity) async {
    late FolderListModel folderListModel;
    final stat = await fileSystemEntity.stat();

    try {
      folderListModel = FolderListModel(
          folderFileName: p.basename(fileSystemEntity.path),
          folderPath: fileSystemEntity.path,
          folderAbsolutePath: fileSystemEntity.absolute.toString(),
          folderSize: stat.size.toDouble(),
          type: stat.type.toString(),
          changeDate: stat.changed,
          accessDate: stat.accessed,
          modifiedDate: stat.modified,
          fileExtension: p.extension(fileSystemEntity.path),
          parentFolder: fileSystemEntity.parent.toString(),
          selected: false);
    } catch (e) {
      print(e.toString());
    }

    return folderListModel;
  }

  Future<String> getCopyFileName(
      String existingFileName, String type, String path) async {
    String tryFileName = existingFileName;
    String newFileName = existingFileName;
    int counter = 0;
    if (type == "file") {
      // io.FileSystemEntity fileSystemEntity = io.File("${path}/${tryFileName}");
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

        if (fileSystemEntity.existsSync()) {
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

  void toggleSelected(FolderListModel folderListModel) {
    try {
      final currentState = state;

      folderListModel.selected = !folderListModel.selected;
      final currrentValue = currentState.whenData((value) => value
          .where((element) => element.folderPath == folderListModel.folderPath)
          .first
          .selected);
      currentState.whenData((value) => value
          .where((element) => element.folderPath == folderListModel.folderPath)
          .first
          .selected = currrentValue as bool);

      state = currentState.whenData((value) => [...value]);
    } catch (e) {
      print(e.toString());
    }
  }
}
