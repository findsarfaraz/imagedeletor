import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:io' as io;

class FolderGridWidget extends StatefulHookConsumerWidget {
  FolderGridWidgetState createState() => FolderGridWidgetState();
}

class FolderGridWidgetState extends ConsumerState<FolderGridWidget> {
  // String sortType = '';
  // String sortColumn = '';
  // String filterColumn = '';
  @override
  Widget build(BuildContext context) {
    final menuSettings = ref.watch(folderSettingNotifierProvider).menuSettings;

    final folderPath = ref.watch(folderPathProvider);
    const monthList = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    void browseDirectory(String path) async {
      await ref.read(folderPathStateNotifierProvider.notifier).updatePath(path);
    }

    ;

    AsyncValue<List<FolderListModel>> folder_list_data =
        ref.watch(folderListFutureProvider);

    Map<SliverPersistentHeader, SliverGrid> sliver_widget_map = {};
    List<Widget> widget_list = [];
    List<String> distinct_type = [];

    if (menuSettings[5] != '0') {
      folder_list_data.whenOrNull(data: (data) {
        int startMonth;
        int endMonth;
        int startYear;
        int endYear;

        startMonth = data.first.modifiedDate.month;
        startYear = data.first.modifiedDate.year;
        endMonth = data.last.modifiedDate.month;
        endYear = data.last.modifiedDate.year;

        var startDate = DateTime(startYear, startMonth, 1);
        var endDate = DateTime(endYear, endMonth + 1, 1);

        while (startDate.difference(endDate).inMicroseconds != 0) {
          List<Widget> new_list_widget = [];

          var x = data
              .where((element) =>
                  element.modifiedDate.month == startDate.month &&
                  element.modifiedDate.year == startDate.year)
              .toList();

          if (x.length > 0) {
            for (var i in x) {
              new_list_widget.add(ListTile(
                  onTap: () {
                    i.type == 'directory'
                        ? browseDirectory(i.folderPath)
                        : null;
                  },
                  key: ObjectKey(i.folderPath),
                  leading: i.type == "directory"
                      ? FaIcon(
                          FontAwesomeIcons.solidFolder,
                          color: Colors.amber,
                        )
                      : FaIcon(
                          FontAwesomeIcons.fileAlt,
                          color: Colors.grey,
                        ),
                  title: Text(i.folderFileName),
                  trailing: FaIcon(FontAwesomeIcons.ellipsisV,
                      color: Colors.black, size: 15)));
            }
            sliver_widget_map[SliverPersistentHeader(
                    key: ObjectKey('Date : ' +
                        startDate.month.toString() +
                        startDate.year.toString()),
                    delegate: RecordPersistentHeader(intl.toBeginningOfSentenceCase(
                        "${monthList[startDate.month - 1]} ${startDate.year.toString()}")!))] =
                SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    delegate: SliverChildListDelegate.fixed(new_list_widget));
          }

          menuSettings[5] == "1"
              ? startDate = DateTime(startDate.year, startDate.month + 1, 1)
              : startDate = DateTime(startDate.year, startDate.month - 1, 1);
        }
      });
    } else {
      folder_list_data.whenOrNull(data: (data) {
        for (var eachData in data) {
          if (!distinct_type.contains(eachData.type)) {
            distinct_type.add(eachData.type);
          }
        }
        distinct_type.sort();
      });

      distinct_type.forEach((objectType) {
        List<Widget> new_list_widget = [];

        folder_list_data.whenOrNull(data: (data) {
          var x = data.where((element) => element.type == objectType);

          for (var i in x) {
            new_list_widget.add(Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                  onTap: () {
                    i.type == 'directory'
                        ? browseDirectory(i.folderPath)
                        : null;
                  },
                  key: ObjectKey(i.folderPath),
                  leading: objectType == "directory"
                      ? FaIcon(
                          FontAwesomeIcons.solidFolder,
                          color: Colors.amber,
                        )
                      : FaIcon(
                          FontAwesomeIcons.fileAlt,
                          color: Colors.grey,
                        ),
                  title: Text(i.folderFileName),
                  trailing: FaIcon(FontAwesomeIcons.ellipsisV,
                      color: Colors.black, size: 15)),
            ));
          }

          sliver_widget_map[SliverPersistentHeader(
              key: ObjectKey(objectType),
              delegate: RecordPersistentHeader(
                  intl.toBeginningOfSentenceCase(objectType)!))] = SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              delegate: SliverChildListDelegate.fixed(new_list_widget));
        });
      });
    }

    sliver_widget_map.forEach((key, value) {
      widget_list.add(key);
      widget_list.add(value);
    });

    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: CustomScrollView(
        slivers: widget_list,
      ),
    );
  }
}

class RecordPersistentHeader extends SliverPersistentHeaderDelegate {
  const RecordPersistentHeader(this.title);

  final String title;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.headline1),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.grey, width: 1.0))));
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
