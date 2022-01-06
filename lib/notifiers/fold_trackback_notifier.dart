import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/folder_trackback_model.dart';

class FolderTrackBackNotifier
    extends StateNotifier<List<FolderTrackBackModel>> {
  FolderTrackBackNotifier() : super([]);

  void modifyFolderBackTrack(String folderName, String folderPath) {
    List<FolderTrackBackModel> folderTrackBackModelList;

    folderTrackBackModelList = state;

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
