import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/providers/favorite_folder_provider.dart';
import 'package:imagedeletor/state_manager/folder_screen_state.dart';

class FavoriteFolderScreen extends ConsumerWidget {
  const FavoriteFolderScreen({Key? key}) : super(key: key);
  static const routeName = '/favoritefolderscreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Customise'),
          actions: [
            IconButton(onPressed: () async {}, icon: Icon(Icons.receipt)),
            IconButton(
                onPressed: () async {
                  ref
                      .watch(favoritefolderNotifierProvider.notifier)
                      .resetSharePreferences();
                },
                icon: Icon(Icons.restart_alt))
          ],
        ),
        body: FolderListWidget());
  }
}

class FolderListWidget extends ConsumerWidget {
  const FolderListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isChecked = false;
    final folder_state = ref.watch(favoritefolderNotifierProvider);
    final folderDetailsInfo =
        ref.watch(favoritefolderNotifierProvider.notifier);
    // final folderSelected = ref.watch(selectedFolders);

    return SingleChildScrollView(
      child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(15),
          child: Text(
            'Categories',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Divider(),
        if (folder_state is FolderScreenInitial)
          CircularProgressIndicator()
        else if (folder_state is FolderScreenLoading)
          CircularProgressIndicator()
        else if (folder_state is FolderScreenLoading)
          CircularProgressIndicator()
        else if (folder_state is FolderScreenLoaded)
          for (var f in folder_state.favoriteFolderModel)
            Container(
              height: 50,
              child: ListView(
                children: [
                  ListTile(
                    leading: f.folder_icon,
                    title: Text(f.folderName),
                    trailing: Checkbox(
                        value: f.status,
                        onChanged: (value) async {
                          await folderDetailsInfo
                              .toggle_favorite_folder_status(f.folder_id);
                          print(f.folder_id);
                          isChecked = value!;
                          print(isChecked);
                        }),
                  )
                ],
              ),
            )
      ]),
    );
  }
}
