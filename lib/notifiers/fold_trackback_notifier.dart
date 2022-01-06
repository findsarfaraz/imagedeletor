import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/misc_function.dart';
import 'package:imagedeletor/model/folder_trackback_model.dart';

class FolderTrackBackNotifier
    extends StateNotifier<List<FolderTrackBackModel>> {
  FolderTrackBackNotifier() : super([]);
  final func_list = MiscFunction();

  void modifyFolderBackTrack(String folderPath) {
    List<FolderTrackBackModel> folderTrackBackModelList;

    folderTrackBackModelList = state;
    final String folderName = func_list.get_folder_name(folderPath);

    folderTrackBackModelList.forEach((element) {
      if (element.folderPath == folderPath) {
        while (element.folderPath != folderPath) {
          folderTrackBackModelList.removeLast();
        }
      } else {
        folderTrackBackModelList.add(FolderTrackBackModel(
            FolderName: folderName, folderPath: folderPath));
      }
      state = folderTrackBackModelList;
    });
  }
}
