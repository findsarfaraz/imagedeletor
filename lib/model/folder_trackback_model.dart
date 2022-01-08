import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderTrackBackModel {
  String folderName;
  String folderPath;

  FolderTrackBackModel({
    required this.folderName,
    required this.folderPath,
  });
}

class FolderTrackBackModelData {
  List<FolderTrackBackModel> folderTrackBackmodelData;

  FolderTrackBackModelData({
    required this.folderTrackBackmodelData,
  });
}
