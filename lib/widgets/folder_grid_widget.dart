import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';

class FolderGridWidget extends HookConsumerWidget {
  String sortType = '';
  String sortColumn = '';
  String filterColumn = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuSettings = ref.watch(folderSettingNotifierProvider).menuSettings;

    if (menuSettings[2] == "1") {
      sortType = 'ASC';
      sortColumn = 'folderName';
    } else if (menuSettings[2] == "2") {
      sortType = 'DESC';
      sortColumn = 'folderName';
    } else if (menuSettings[3] == "1") {
      sortType = 'ASC';
      sortColumn = 'folderSize';
    } else if (menuSettings[3] == "2") {
      sortType = 'DESC';
      sortColumn = 'folderSize';
    } else if (menuSettings[4] == "1") {
      sortType = 'ASC';
      sortColumn = 'fileExtension';
    } else if (menuSettings[4] == "2") {
      sortType = 'DESC';
      sortColumn = 'fileExtension';
    } else if (menuSettings[5] == "1") {
      sortType = 'ASC';
      sortColumn = 'accessDate';
    } else if (menuSettings[5] == "2") {
      sortType = 'DESC';
      sortColumn = 'accessDate';
    }

    if (menuSettings[7] == "1") {
      filterColumn = 'picture';
    } else if (menuSettings[8] == "1") {
      print('test ran');
      filterColumn = 'video';
    } else if (menuSettings[9] == "1") {
      filterColumn = 'document';
    } else if (menuSettings[10] == "1") {
      filterColumn = 'music';
    }

    AsyncValue<List<FolderListModel>> folder_list_data =
        ref.watch(folderListSorted([sortType, sortColumn, filterColumn]));

    return Container(
        color: Colors.white.withOpacity(0),
        child: folder_list_data.when(
            data: (data) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 3),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.black26, width: 1.0)),
                      child: ListTile(
                        title: Transform.translate(
                          offset: Offset(-22, 0),
                          child: Text(data[index].folderFileName,
                              style: Theme.of(context).textTheme.bodyText2),
                        ),
                        leading: data[index].type == "directory"
                            ? FaIcon(
                                FontAwesomeIcons.solidFolder,
                                color: Colors.amber,
                              )
                            : FaIcon(FontAwesomeIcons.fileAlt,
                                color: Colors.grey),
                        trailing: FaIcon(
                          FontAwesomeIcons.ellipsisV,
                          size: 15,
                          color: Colors.black,
                        ),
                        onTap: () {
                          data[index].type == "directory"
                              ? ref
                                  .read(folderListAsyncProvider.notifier)
                                  .fetch(data[index].folderPath)
                              : null;
                          ref.read(folderPathProvier.state).state =
                              data[index].folderFileName.toString();
                        },
                      ),
                    );
                  });
            },
            error: (error, st) => Center(child: Text(error.toString())),
            loading: () => Center(child: CircularProgressIndicator())));
  }
}
