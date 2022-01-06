import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/file_type_filter_model.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/notifiers/folder_list_screen_notifier.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:io' as io;

final folderListAsyncProvider =
    StateNotifierProvider<FolderListStateNotifier, List<FolderListModel>>(
        (ref) {
  return FolderListStateNotifier();
});

final folderStateProvider = StateProvider<List<FolderListModel>>((ref) {
  List<FolderListModel> requireData = [];
  List<FolderListModel> filterData = [];

  final data = ref.watch(folderListAsyncProvider);
  final menuSettings = ref.watch(folderSettingNotifierProvider).menuSettings;
  final filterList = ref.watch(providerFilterListProvider).filterList;

  requireData = data
      .where((element) =>
          ((element.type == "directory" &&
              element.folderFileName.substring(0, 1) != ".")) ||
          (element.type == "file" &&
              element.folderFileName.substring(0, 1) != "."))
      .toList();

  if (menuSettings[2] == '1') {
    requireData.sort((a, b) {
      return a.folderFileName
          .toString()
          .toLowerCase()
          .compareTo(b.folderFileName.toString().toLowerCase());
    });
  } else if (menuSettings[2] == '2') {
    requireData.sort((a, b) {
      return b.folderFileName
          .toString()
          .toLowerCase()
          .compareTo(a.folderFileName.toString().toLowerCase());
    });
  } else if (menuSettings[3] == '1') {
    requireData.sort((a, b) {
      return a.folderSize.compareTo(b.folderSize);
    });
  } else if (menuSettings[3] == '2') {
    requireData.sort((a, b) {
      return b.folderSize.compareTo(a.folderSize);
    });
  } else if (menuSettings[4] == '1') {
    requireData.sort((a, b) {
      return a.fileExtension
          .toString()
          .toLowerCase()
          .compareTo(b.fileExtension.toString().toLowerCase());
    });
  } else if (menuSettings[4] == '2') {
    requireData.sort((a, b) {
      return b.fileExtension
          .toString()
          .toLowerCase()
          .compareTo(a.fileExtension.toString().toLowerCase());
    });
  } else if (menuSettings[5] == '1') {
    requireData.sort((a, b) {
      return a.modifiedDate.compareTo(b.modifiedDate);
    });
  } else if (menuSettings[5] == '2') {
    requireData.sort((a, b) {
      return b.modifiedDate.compareTo(a.modifiedDate);
    });
  }

  if (menuSettings[7] == '1') {
    filterData = requireData
        .where((element) => ((filterList['picture']!)
                .contains(element.fileExtension.toLowerCase()) ||
            element.type == "directory"))
        .toList();
  } else if (menuSettings[8] == '1') {
    filterData = requireData
        .where((element) =>
            (filterList['video']!)
                .contains(element.fileExtension.toLowerCase()) ||
            element.type == "directory")
        .toList();
  } else if (menuSettings[9] == '1') {
    filterData = requireData
        .where((element) =>
            (filterList['document']!)
                .contains(element.fileExtension.toLowerCase()) ||
            element.type == "directory")
        .toList();
  } else if (menuSettings[10] == '1') {
    filterData = requireData
        .where((element) =>
            ((filterList['music']!)
                .contains(element.fileExtension.toLowerCase())) ||
            element.type == "directory")
        .toList();
  } else {
    filterData = requireData;
  }
  return filterData;
});

final folderListFutureProvider = FutureProvider((ref) async {
  final data = await ref.watch(folderStateProvider);

  return data;
});

// final folderListSorted =
//     Provider.family<AsyncValue<List<FolderListModel>>, List<String>>(
//         (ref, sortDetails) {
//   final data = ref.watch(folderListAsyncProvider);
//   final filterList = ref.watch(providerFilterListProvider).filterList;

//   AsyncValue<List<FolderListModel>> filterData;

//   data.whenData((value) => value.forEach((element) {
//         if (element.type == "File") {
//           print("${element.folderAbsolutePath}  ${element.folderFileName}");
//         }
//       }));

//   late AsyncValue<List<FolderListModel>> requireData;

//   requireData = data.whenData((value) => value
//       .where((element) =>
//           (element.type == "directory" &&
//               element.folderFileName.substring(0, 1) != ".") ||
//           element.type == "file")
//       .toList());

//   print(
//       "File exists : ${io.File('storage/emulated/0/QTAudioEngine').existsSync().toString()}");

//   if (sortDetails[0] == 'ASC' && sortDetails[1] == 'folderName') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return a.folderFileName
//             .toString()
//             .toLowerCase()
//             .compareTo(b.folderFileName.toString().toLowerCase());
//       });
//     });
//   } else if (sortDetails[0] == 'DESC' && sortDetails[1] == 'folderName') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return b.folderFileName
//             .toString()
//             .toLowerCase()
//             .compareTo(a.folderFileName.toString().toLowerCase());
//       });
//     });
//   } else if (sortDetails[0] == 'ASC' && sortDetails[1] == 'folderSize') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return a.folderSize.compareTo(b.folderSize);
//       });
//     });
//   } else if (sortDetails[0] == 'DESC' && sortDetails[1] == 'folderSize') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return b.folderSize.compareTo(a.folderSize);
//       });
//     });
//   } else if (sortDetails[0] == 'ASC' && sortDetails[1] == 'fileExtension') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return a.fileExtension
//             .toString()
//             .toLowerCase()
//             .compareTo(b.fileExtension.toString().toLowerCase());
//       });
//     });
//   } else if (sortDetails[0] == 'DESC' && sortDetails[1] == 'fileExtension') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return b.fileExtension
//             .toString()
//             .toLowerCase()
//             .compareTo(a.fileExtension.toString().toLowerCase());
//       });
//     });
//   } else if (sortDetails[0] == 'ASC' && sortDetails[1] == 'modifiedDate') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return a.modifiedDate.compareTo(b.modifiedDate);
//       });
//     });
//   } else if (sortDetails[0] == 'DESC' && sortDetails[1] == 'modifiedDate') {
//     requireData.whenData((value) {
//       value.sort((a, b) {
//         return b.modifiedDate.compareTo(a.modifiedDate);
//       });
//     });
//   }

//   if (sortDetails[2] == 'picture') {
//     filterData = requireData.whenData((value) => value
//         .where((element) => ((filterList['picture']!)
//                 .contains(element.fileExtension.toLowerCase()) ||
//             element.type == "directory"))
//         .toList());
//   } else if (sortDetails[2] == 'video') {
//     filterData = requireData.whenData((value) => value
//         .where((element) =>
//             (filterList['video']!)
//                 .contains(element.fileExtension.toLowerCase()) ||
//             element.type == "directory")
//         .toList());
//   } else if (sortDetails[2] == 'document') {
//     filterData = requireData.whenData((value) => value
//         .where((element) =>
//             (filterList['document']!)
//                 .contains(element.fileExtension.toLowerCase()) ||
//             element.type == "directory")
//         .toList());
//   } else if (sortDetails[2] == 'music') {
//     filterData = requireData.whenData((value) => value
//         .where((element) =>
//             ((filterList['music']!)
//                 .contains(element.fileExtension.toLowerCase())) ||
//             element.type == "directory")
//         .toList());
//   } else {
//     filterData = requireData;
//   }

//   return filterData;
// });

final providerFilterListProvider = Provider<FileTypeFilterModel>((ref) {
  return FileTypeFilterModel("");
});
