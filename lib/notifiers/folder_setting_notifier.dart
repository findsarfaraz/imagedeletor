import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/model/folder_menu_settings.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class FolderSettingNotifier extends StateNotifier<FolderViewModel> {
  FolderSettingNotifier(state) : super(state);

  initializeMenuSettings(String folderPath) async {
    final prefs = await _prefs;

    final initialSettings = await prefs.getStringList(folderPath);

    if (initialSettings != null) {
      state = FolderViewModel(initialSettings, 0);
    }
  }

  saveMenuSettings(String folderPath) async {
    final prefs = await _prefs;
    FolderViewModel fvm = state;
    await prefs.setStringList(folderPath, fvm.menuSettings);
  }
}
