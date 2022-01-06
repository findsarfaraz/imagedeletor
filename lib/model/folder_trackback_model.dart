import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderTrackBackModel {
  String FolderName;
  String folderPath;

  FolderTrackBackModel({
    required this.FolderName,
    required this.folderPath,
  });
}

class FolderTrackBackData with ChangeNotifier {
  List<FolderTrackBackModel> folderTrackBack;

  FolderTrackBackData({
    required this.folderTrackBack,
  });

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
