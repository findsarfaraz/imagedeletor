import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/model/app_exception_model.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/model/folder_menu_settings.dart';
import 'package:imagedeletor/providers/app_exception_provider.dart';
import 'package:imagedeletor/providers/folder_copy_paste_function_provider.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'package:imagedeletor/widgets/popmenu_function_widget.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:io' as io;

class FolderListWidget extends ConsumerWidget {
// {
//   FolderListWidgetState createState() => FolderListWidgetState();
// }

// bool isLoading = false;

// class FolderListWidgetState extends ConsumerState<FolderListWidget> {
//   @override
  bool multiSelectMode = false;
  int countSelected = 0;

  final List<FolderViewModel> selected = [];
  Widget build(BuildContext context, WidgetRef ref) {
    final menuSettings = ref.watch(folderSettingNotifierProvider).menuSettings;

    ref.listen(appMsgProvider, (previous, next) {
      final snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text(next.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    ref.listen<AsyncValue<List<FolderListModel>>>(folderStateProvider,
        (previous, next) {
      final selectedCount = next
          .whenData((value) => value
              .where((element) => element.selected == true)
              .toList()
              .length)
          .value;

      print(
          "VALUE OF SELECTED COUNT ${selectedCount.toString()} ${multiSelectMode.toString()} ");
      if (selectedCount == 0) {
        print("ran selected count");
        multiSelectMode = false;
      } else if (selectedCount != 0) {
        multiSelectMode = true;
      }
      print(
          "VALUE OF SELECTED COUNT ${selectedCount.toString()} ${multiSelectMode.toString()} ");
    });

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

    AsyncValue<List<FolderListModel>> folder_list_data =
        ref.watch(folderStateProvider);

    Map<SliverToBoxAdapter, SliverList> sliver_widget_map = {};
    List<Widget> widget_list = [];
    List<String> distinct_type = [];

    return folder_list_data.when(
        data: (data) {
          data.forEach((element) {
            element.type.toString();
          });
          if (data.isNotEmpty) {
            if (menuSettings[5] != '0') {
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
                  x.forEach((i) {
                    new_list_widget.add(ListTile(
                        onLongPress: () {
                          ref
                              .read(folderListAsyncProvider.notifier)
                              .toggleSelected(i);
                        },
                        onTap: () async {
                          !multiSelectMode && i.type == 'directory'
                              ? await ref
                                  .read(
                                      folderPathStateNotifierProvider.notifier)
                                  .updatePath(i.folderPath)
                              : ref
                                  .read(folderListAsyncProvider.notifier)
                                  .toggleSelected(i);
                        },
                        key: ObjectKey(i.folderPath),
                        leading: Container(
                          alignment: Alignment.center,
                          width: 50,
                          child: i.type == "directory"
                              ? i.selected
                                  ? FaIcon(FontAwesomeIcons.checkCircle,
                                      color: Colors.blue)
                                  : FaIcon(FontAwesomeIcons.solidFolder,
                                      color: Colors.amber)
                              : i.selected
                                  ? FaIcon(FontAwesomeIcons.checkCircle,
                                      color: Colors.blue)
                                  : FaIcon(FontAwesomeIcons.fileAlt,
                                      color: Colors.grey),
                        ),
                        title: Text(i.folderFileName),
                        trailing: FaIcon(FontAwesomeIcons.ellipsisV,
                            color: Colors.black, size: 15)));
                  });

                  sliver_widget_map[SliverToBoxAdapter(
                      key: ObjectKey('Date : ' +
                          startDate.month.toString() +
                          startDate.year.toString()),
                      child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "${intl.toBeginningOfSentenceCase(monthList[startDate.month - 1].toString())} -  ${startDate.year.toString()}",
                              style: Theme.of(context).textTheme.headline1),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0)))))] = SliverList(
                      delegate: SliverChildListDelegate.fixed(new_list_widget));
                }

                menuSettings[5] == "1"
                    ? startDate =
                        DateTime(startDate.year, startDate.month + 1, 1)
                    : startDate =
                        DateTime(startDate.year, startDate.month - 1, 1);
              }
            } else {
              data.forEach((eachData) {
                if (!distinct_type.contains(eachData.type)) {
                  distinct_type.add(eachData.type);
                }
              });
              distinct_type.sort();

              print(distinct_type.toString());
              distinct_type.forEach((objectType) {
                List<Widget> new_list_widget = [];
                var x = data.where((element) => element.type == objectType);
                if (x.length > 0) {
                  x.forEach((i) {
                    new_list_widget.add(ListTile(
                        onLongPress: () {
                          ref
                              .read(folderListAsyncProvider.notifier)
                              .toggleSelected(i);
                        },
                        onTap: () async {
                          !multiSelectMode && i.type == 'directory'
                              ? await ref
                                  .read(
                                      folderPathStateNotifierProvider.notifier)
                                  .updatePath(i.folderPath)
                              : ref
                                  .read(folderListAsyncProvider.notifier)
                                  .toggleSelected(i);
                        },
                        key: ObjectKey(i.folderPath),
                        leading: Container(
                          alignment: Alignment.center,
                          width: 50,
                          child: i.type == "directory"
                              ? (i.selected
                                  ? FaIcon(FontAwesomeIcons.checkCircle,
                                      color: Colors.blue)
                                  : FaIcon(FontAwesomeIcons.solidFolder,
                                      color: Colors.amber))
                              : (i.selected
                                  ? FaIcon(FontAwesomeIcons.checkCircle,
                                      color: Colors.blue)
                                  : FaIcon(FontAwesomeIcons.fileAlt,
                                      color: Colors.grey)),
                        ),
                        title: Text(i.folderFileName),
                        trailing:
                            PopupMenuFunctionWidget(i.folderPath, i.type)));
                  });

                  sliver_widget_map[SliverToBoxAdapter(
                      key: ObjectKey(objectType),
                      child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                              intl.toBeginningOfSentenceCase(objectType)!,
                              style: Theme.of(context).textTheme.headline1),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0)))))] = SliverList(
                      delegate: SliverChildListDelegate.fixed(new_list_widget));
                }
              });
            }
            sliver_widget_map.forEach((key, value) {
              widget_list.add(key);
              widget_list.add(value);
            });
          }
          return Container(
              color: Colors.white,
              child: CustomScrollView(
                slivers: widget_list,
              ));
        },
        error: (err, st) {
          return Center(child: Text(err.toString()));
        },
        loading: () => Center(child: CircularProgressIndicator()));
  }
}

class FolderListBuilder extends StatelessWidget {
  const FolderListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
