import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/misc_function.dart';
import 'package:imagedeletor/model/folder_trackback_model.dart';

class FolderTrackBackNotifier
    extends StateNotifier<List<FolderTrackBackModel>> {
  FolderTrackBackNotifier() : super([]);
  final func_list = MiscFunction();

  void modifyFolderBackTrack(String folderPath) async {
    List<FolderTrackBackModel> folderTrackBackModelList;

    folderTrackBackModelList = state;
    final String folderName = func_list.get_folder_name(folderPath);
    try {
      if (folderTrackBackModelList.length > 0) {
        final value = folderTrackBackModelList
            .where((element) => element.folderPath == folderPath);
        if (value.isNotEmpty) {
          removeFolderPath(folderPath);
        } else {
          folderTrackBackModelList.add(FolderTrackBackModel(
              folderName: folderName, folderPath: folderPath));
        }
      } else {
        folderTrackBackModelList.add(FolderTrackBackModel(
            folderName: folderName, folderPath: folderPath));
      }
      state = [...folderTrackBackModelList];
    } catch (e) {
      print("ERROR: modifyFolderBackTrack ${e.toString()}");
    }
  }

  void removeFolderPath(String path) {
    List<FolderTrackBackModel> folderTrackBackModelList;
    folderTrackBackModelList = state;
    final firstElement = folderTrackBackModelList
        .where((element) => element.folderPath == path)
        .first;
    final lastElement = folderTrackBackModelList.last;

    final firstIndex = folderTrackBackModelList.indexOf(firstElement) + 1;
    final lastIndex = folderTrackBackModelList.indexOf(lastElement) + 1;

    if (firstIndex == lastIndex) {
      folderTrackBackModelList.removeAt(lastIndex);
    } else {
      folderTrackBackModelList.removeRange(firstIndex, lastIndex);
    }
    folderTrackBackModelList.forEach((element) {
      print(element.folderName);
    });
    state = folderTrackBackModelList;
  }
}
