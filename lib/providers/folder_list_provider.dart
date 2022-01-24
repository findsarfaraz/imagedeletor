import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/file_type_filter_model.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/notifiers/folder_list_screen_notifier.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:riverpod/riverpod.dart';

final providerFilterListProvider = Provider<FileTypeFilterModel>((ref) {
  return FileTypeFilterModel("");
});

final folderListAsyncProvider = StateNotifierProvider<FolderListStateNotifier,
    AsyncValue<List<FolderListModel>>>((ref) {
  return FolderListStateNotifier(ref);
});

final folderStateProvider =
    StateProvider<AsyncValue<List<FolderListModel>>>((ref) {
  // AsyncValue<List<FolderListModel>> requireData =
  //     ref.watch(folderListAsyncProvider);
  AsyncValue<List<FolderListModel>> filterData;

  AsyncValue<List<FolderListModel>> requireData =
      ref.watch(folderListAsyncProvider);
  final menuSettings = ref.watch(folderSettingNotifierProvider).menuSettings;
  final filterList = ref.watch(providerFilterListProvider).filterList;

  if (menuSettings[2] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.folderFileName
            .toString()
            .toLowerCase()
            .compareTo(b.folderFileName.toString().toLowerCase());
      });
    });
  } else if (menuSettings[2] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.folderFileName
            .toString()
            .toLowerCase()
            .compareTo(a.folderFileName.toString().toLowerCase());
      });
    });
  } else if (menuSettings[3] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.folderSize.compareTo(b.folderSize);
      });
    });
  } else if (menuSettings[3] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.folderSize.compareTo(a.folderSize);
      });
    });
  } else if (menuSettings[4] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.fileExtension
            .toString()
            .toLowerCase()
            .compareTo(b.fileExtension.toString().toLowerCase());
      });
    });
  } else if (menuSettings[4] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.fileExtension
            .toString()
            .toLowerCase()
            .compareTo(a.fileExtension.toString().toLowerCase());
      });
    });
  } else if (menuSettings[5] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.modifiedDate.compareTo(b.modifiedDate);
      });
    });
  } else if (menuSettings[5] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.modifiedDate.compareTo(a.modifiedDate);
      });
    });
  }

  if (menuSettings[7] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['picture']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else if (menuSettings[8] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['video']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else if (menuSettings[9] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['document']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else if (menuSettings[10] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['music']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else {
    filterData = requireData;
  }
  return filterData;

  // return requireData;
});

final folderListProviderSorted = Provider((ref) {
  AsyncValue<List<FolderListModel>> filterData;

  AsyncValue<List<FolderListModel>> requireData =
      ref.watch(folderStateProvider);

  final menuSettings = ref.watch(folderSettingNotifierProvider).menuSettings;
  final filterList = ref.watch(providerFilterListProvider).filterList;

  if (menuSettings[2] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.folderFileName
            .toString()
            .toLowerCase()
            .compareTo(b.folderFileName.toString().toLowerCase());
      });
    });
  } else if (menuSettings[2] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.folderFileName
            .toString()
            .toLowerCase()
            .compareTo(a.folderFileName.toString().toLowerCase());
      });
    });
  } else if (menuSettings[3] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.folderSize.compareTo(b.folderSize);
      });
    });
  } else if (menuSettings[3] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.folderSize.compareTo(a.folderSize);
      });
    });
  } else if (menuSettings[4] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.fileExtension
            .toString()
            .toLowerCase()
            .compareTo(b.fileExtension.toString().toLowerCase());
      });
    });
  } else if (menuSettings[4] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.fileExtension
            .toString()
            .toLowerCase()
            .compareTo(a.fileExtension.toString().toLowerCase());
      });
    });
  } else if (menuSettings[5] == '1') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return a.modifiedDate.compareTo(b.modifiedDate);
      });
    });
  } else if (menuSettings[5] == '2') {
    requireData.whenData((value) {
      value.sort((a, b) {
        return b.modifiedDate.compareTo(a.modifiedDate);
      });
    });
  }

  if (menuSettings[7] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['picture']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else if (menuSettings[8] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['video']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else if (menuSettings[9] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['document']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else if (menuSettings[10] == '1') {
    filterData = requireData.whenData((value) => value
        .where((element) => ((filterList['music']!)
                .contains(element.fileExtension.toLowerCase()) ||
            (element.type == "directory")))
        .toList());
  } else {
    filterData = requireData;
  }
  return filterData;
});

// final folderListFutureProvider = FutureProvider((ref) async {
//   final data = await ref.watch(folderStateProvider);
//   ref.read(folderLoadingStateProvider.state).state = false;
//   return data;
// });

final folderLoadingStateProvider = StateProvider<bool>((ref) {
  return false;
});
