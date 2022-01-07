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
    try {
      if (folderTrackBackModelList.length > 0) {
        folderTrackBackModelList.forEach((element) {
          if (element.folderPath == folderPath) {
            removeFolderPath(folderPath);
          } else {
            folderTrackBackModelList.add(FolderTrackBackModel(
                FolderName: folderName, folderPath: folderPath));
          }
        });
      } else {
        folderTrackBackModelList.add(FolderTrackBackModel(
            FolderName: folderName, folderPath: folderPath));
      }
    } catch (e) {
      print("ERROR: modifyFolderBackTrack ${e.toString()}");
    }

    state = folderTrackBackModelList;
  }

  void removeFolderPath(String path) {
    List<FolderTrackBackModel> folderTrackBackModelList;
    folderTrackBackModelList = state;
    final firstElement = folderTrackBackModelList
        .where((element) => element.folderPath == path)
        .first;
    final lastElement = folderTrackBackModelList.last;

    final firstIndex = folderTrackBackModelList.indexOf(firstElement) + 1;
    final lastIndex = folderTrackBackModelList.indexOf(lastElement);

    folderTrackBackModelList.removeRange(firstIndex, lastIndex + 1);
    state = folderTrackBackModelList;
  }
}
