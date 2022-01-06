import 'package:flutter/cupertino.dart';
import 'package:imagedeletor/model/folder_trackback_model.dart';

class FolderTrackBackNotifier with ChangeNotifier {
  void modifyFolderBackTrack(String folderName, String folderPath) {
    List<FolderTrackBackModel> folderTrackBackModel = [];

    folderTrackBackModel.forEach((element) {
      if (element.folderPath == folderPath) {
        while (element.folderPath != folderPath) {
          folderTrackBackModel.removeLast();
        }
      } else {
        folderTrackBackModel.add(FolderTrackBackModel(
            FolderName: folderName, folderPath: folderPath));
      }
    });
  }
}
