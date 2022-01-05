import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imagedeletor/model/favorite_folder_model.dart';
import 'package:imagedeletor/notifiers/favorite_folder_notifier.dart';
import 'package:imagedeletor/state_manager/folder_screen_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

abstract class FavoriteFolderRespository {
  Future<List<FavoriteFolderModel>> getFavoriteFolderList();
}

class FakeFavoriteFolderRepository implements FavoriteFolderRespository {
  @override
  Future<List<FavoriteFolderModel>> getFavoriteFolderList() async {
    final SharedPreferences prefs = await _prefs;

    final List<String> sharedPFFavFolder =
        prefs.getStringList('fav_folder') ?? [];

    List<FavoriteFolderModel> _initialFolderList = [
      FavoriteFolderModel(
          folder_id: 'a1',
          folderName: 'Recent',
          folderPath: 'folder/Recent',
          folder_icon: FaIcon(
            FontAwesomeIcons.cogs,
            color: Colors.amber,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a2',
          folderName: 'Pictures',
          folderPath: 'folder/Pictures',
          folder_icon: FaIcon(
            FontAwesomeIcons.image,
            color: Colors.blue,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a3',
          folderName: 'Vault',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.lock,
            color: Colors.red,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a4',
          folderName: 'Videos',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.video,
            color: Colors.green,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a5',
          folderName: 'Archives',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.fileArchive,
            color: Colors.pink,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a6',
          folderName: 'Music',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.music,
            color: Colors.blueGrey,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a7',
          folderName: 'Documents',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.dochub,
            color: Colors.deepOrange,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a8',
          folderName: 'Recyclebin',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.dumpster,
            color: Colors.lime,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a9',
          folderName: 'Downloads',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.download,
            color: Colors.deepPurple,
            size: 15,
          ),
          status: false),
      FavoriteFolderModel(
          folder_id: 'a10',
          folderName: 'Screenshots',
          folderPath: 'folder/test1',
          folder_icon: FaIcon(
            FontAwesomeIcons.photoVideo,
            color: Colors.teal,
            size: 15,
          ),
          status: false)
    ];

    for (var folders in _initialFolderList) {
      if (sharedPFFavFolder.contains(folders.folder_id)) folders.status = true;
    }

    return _initialFolderList;
  }
}

final favoriteFolderProvider = Provider<FavoriteFolderRespository>(
    (ref) => FakeFavoriteFolderRepository());

final favoritefolderNotifierProvider =
    StateNotifierProvider<FavoriteFolderNotifier, FolderScreenState>(
  (ref) => FavoriteFolderNotifier(ref.watch(favoriteFolderProvider)),
);
