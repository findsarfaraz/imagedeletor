import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/model/folder_menu_settings.dart';
import 'package:imagedeletor/notifiers/folder_setting_notifier.dart';

final folderSettingNotifierProvider =
    StateNotifierProvider<FolderSettingNotifier, FolderViewModel>((ref) {
  final providerMenuSettings = ref.watch(providerSettingsForMenu);
  return FolderSettingNotifier(providerMenuSettings);
});

final providerSettingsForMenu = ChangeNotifierProvider<FolderViewModel>((ref) {
  return FolderViewModel(
      ['1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0'], 0);
});
