import 'package:imagedeletor/providers/favorite_folder_provider.dart';
import 'package:imagedeletor/state_manager/folder_screen_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteFolderNotifier extends StateNotifier<FolderScreenState> {
  FavoriteFolderRespository favoriteFolderRespository;

  FavoriteFolderNotifier(this.favoriteFolderRespository)
      : super(FolderScreenInitial());

  Future<void> getFolderForNotifier() async {
    try {
      // throw ('This is not found');
      state = FolderScreenLoading();
      final favFolder = await favoriteFolderRespository.getFavoriteFolderList();
      state = FolderScreenLoaded(favFolder);
    } catch (e) {
      state = FolderScreenError(e.toString());
    }
  }

  Future<void> toggle_favorite_folder_status(String folder_id) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    List<String> sharedPFFavFolder = prefs.getStringList('fav_folder')!;

    if (sharedPFFavFolder.contains(folder_id))
      sharedPFFavFolder.remove(folder_id);
    else
      sharedPFFavFolder.add(folder_id);

    final favFolder = await favoriteFolderRespository.getFavoriteFolderList();

    final int indexupdate =
        favFolder.indexWhere((element) => element.folder_id == folder_id);
    favFolder[indexupdate].status = !favFolder[indexupdate].status;

    state = FolderScreenLoaded(favFolder);

    prefs.setStringList('fav_folder', sharedPFFavFolder);
    List<String> sharedPFFavFolder_new = prefs.getStringList('fav_folder')!;
    print(sharedPFFavFolder_new);
  }

  Future<void> resetSharePreferences() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("fav_folder", []);
    final testFav = prefs.getStringList('fav_folder');
    print(testFav);
  }
}
