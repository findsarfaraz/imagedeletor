import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imagedeletor/providers/favorite_folder_provider.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'package:imagedeletor/screens/folder_list_screen.dart';
import 'package:imagedeletor/state_manager/folder_screen_state.dart';
import 'package:imagedeletor/state_manager/home_screen_state.dart';
import 'package:imagedeletor/widgets/favorite_folder_widget.dart';

import 'providers/disk_info_provider.dart';
import 'widgets/disk_space_widget.dart';

class BodyScreen extends ConsumerWidget {
  static final routeName = "/bodyscreen";
  final Map<String, String> folder_path = {};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeScreenNotifierProvider);
    final folder_state = ref.watch(favoritefolderNotifierProvider);

    // final folderList = ref.watch(selectedFolders);

    ref.listen(homeScreenNotifierProvider, (previous, next) {
      if (next is HomeScreenError) {
        final snackBar = SnackBar(
          content: Text(next.message.toString()),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    return Consumer(builder: (context, watch, child) {
      if (state is HomeScreenInitial) {
        return Center(child: Text('Initial', style: TextStyle(fontSize: 40)));
      } else if (state is HomeScreenLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is HomeScreenLoaded) {
        return Column(children: [
          Flexible(
              fit: FlexFit.loose,
              flex: 3,
              child: InkWell(
                child: Container(
                  child: DiskSpaceWidget(
                      'Internal Storage', Colors.red, state.sizeInfo),
                ),
                onTap: () {
                  // ref.read(folderPathStateProvider.state).state =
                  //     '/storage/emulated/0';
                  ref
                      .read(folderPathStateNotifierProvider.notifier)
                      .updatePath('/storage/emulated/0');

                  // await ref
                  //     .read(folderPathStateNotifierProvider.notifier)
                  //     .updatePath(
                  //         '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/Whatsapp Images');

                  Navigator.of(context).pushNamed(FolderListScreen.routeName);

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     settings: RouteSettings(name: FolderListScreen.routeName),
                  //     builder: (context) => FolderListScreen(),
                  //   ),
                  // );
                },
              )),
          Flexible(
              fit: FlexFit.loose,
              flex: 12,
              child: Container(
                margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: GridView.count(
                  childAspectRatio: 2.5,
                  crossAxisCount: 2,
                  children: [
                    if (folder_state is FolderScreenLoaded)
                      for (var f in folder_state.favoriteFolderModel)
                        if (f.status)
                          FavoriteFolderWidget(f.folderName, f.folder_icon)
                  ],
                ),
              ))
        ]);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
