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

class FolderTrackBackData {
  List<FolderTrackBackModel> folderTrackBack;
  FolderTrackBackData({
    required this.folderTrackBack,
  });
}
