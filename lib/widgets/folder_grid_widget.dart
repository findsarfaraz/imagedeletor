// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:imagedeletor/model/folder_list_model.dart';
// import 'package:imagedeletor/providers/folder_list_provider.dart';
// import 'package:imagedeletor/providers/folder_setting_provider.dart';
// import 'package:imagedeletor/providers/folder_trackback_provider.dart';
// import 'package:imagedeletor/providers/generic_provider.dart';
// import 'package:intl/intl.dart' as intl;
// import 'dart:io' as io;

// class FolderGridWidget extends StatefulHookConsumerWidget {
//   FolderGridWidgetState createState() => FolderGridWidgetState();
// }

// // bool isLoading = false;

// class FolderGridWidgetState extends ConsumerState<FolderGridWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final menuSettings = ref.watch(folderSettingNotifierProvider).menuSettings;

//     // final folderPath = ref.watch(folderPathProvider);

//     final loadingState = ref.watch(folderLoadingStateProvider);
//     // ref.listen(folderListFutureProvider, (previous, next) {
//     //   isLoading = false;
//     // });

//     const monthList = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec"
//     ];

//     AsyncValue<List<FolderListModel>> folder_list_data =
//         ref.watch(folderListFutureProvider);

//     Map<SliverToBoxAdapter, SliverGrid> sliver_widget_map = {};
//     List<Widget> widget_list = [];
//     List<String> distinct_type = [];

//     return folder_list_data.when(
//         data: (data) {
//           if (menuSettings[5] != '0') {
//             int startMonth;
//             int endMonth;
//             int startYear;
//             int endYear;

//             startMonth = data.first.modifiedDate.month;
//             startYear = data.first.modifiedDate.year;
//             endMonth = data.last.modifiedDate.month;
//             endYear = data.last.modifiedDate.year;

//             var startDate = DateTime(startYear, startMonth, 1);
//             var endDate = DateTime(endYear, endMonth + 1, 1);

//             while (startDate.difference(endDate).inMicroseconds != 0) {
//               List<Widget> new_list_widget = [];

//               var x = data
//                   .where((element) =>
//                       element.modifiedDate.month == startDate.month &&
//                       element.modifiedDate.year == startDate.year)
//                   .toList();

//               if (x.length > 0) {
//                 x.forEach((i) {
//                   new_list_widget.add(Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black26),
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: ListTile(
//                         onTap: () {
//                           i.type == 'directory'
//                               ? ref
//                                   .read(
//                                       folderPathStateNotifierProvider.notifier)
//                                   .updatePath(i.folderPath)
//                               : null;
//                           ref.read(folderLoadingStateProvider.state).state =
//                               true;
//                           // setState(() {
//                           //   isLoading = true;
//                           // });
//                         },
//                         key: ObjectKey(i.folderPath),
//                         leading: i.type == "directory"
//                             ? FaIcon(
//                                 FontAwesomeIcons.solidFolder,
//                                 color: Colors.amber,
//                               )
//                             : FaIcon(
//                                 FontAwesomeIcons.fileAlt,
//                                 color: Colors.grey,
//                               ),
//                         title: Text(i.folderFileName),
//                         trailing: FaIcon(FontAwesomeIcons.ellipsisV,
//                             color: Colors.black, size: 15)),
//                   ));
//                 });

//                 sliver_widget_map[SliverToBoxAdapter(
//                     key: ObjectKey('Date : ' +
//                         startDate.month.toString() +
//                         startDate.year.toString()),
//                     child: Container(
//                         padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                         height: 50,
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                             "${intl.toBeginningOfSentenceCase(monthList[startDate.month - 1].toString())} -  ${startDate.year.toString()}",
//                             style: Theme.of(context).textTheme.headline1),
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.grey,
//                                     width: 1.0)))))] = SliverGrid(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2),
//                     delegate: SliverChildListDelegate.fixed(new_list_widget));
//               }

//               menuSettings[5] == "1"
//                   ? startDate = DateTime(startDate.year, startDate.month + 1, 1)
//                   : startDate =
//                       DateTime(startDate.year, startDate.month - 1, 1);
//             }
//           } else {
//             data.forEach((eachData) {
//               if (!distinct_type.contains(eachData.type)) {
//                 distinct_type.add(eachData.type);
//               }
//             });
//             distinct_type.sort();
//             distinct_type.forEach((objectType) {
//               List<Widget> new_list_widget = [];
//               var x = data.where((element) => element.type == objectType);
//               if (x.length > 0) {
//                 x.forEach((i) {
//                   new_list_widget.add(ListTile(
//                       onTap: () async {
//                         print("function called");

//                         i.type == 'directory'
//                             ? await ref
//                                 .read(folderPathStateNotifierProvider.notifier)
//                                 .updatePath(i.folderPath)
//                             : null;

//                         ref.read(folderLoadingStateProvider.state).state = true;
//                         // setState(() {
//                         //   isLoading = true;
//                         // });
//                       },
//                       key: ObjectKey(i.folderPath),
//                       leading: i.type == "directory"
//                           ? FaIcon(
//                               FontAwesomeIcons.solidFolder,
//                               color: Colors.amber,
//                             )
//                           : FaIcon(
//                               FontAwesomeIcons.fileAlt,
//                               color: Colors.grey,
//                             ),
//                       title: Text(i.folderFileName),
//                       trailing: FaIcon(FontAwesomeIcons.ellipsisV,
//                           color: Colors.black, size: 15)));
//                 });

//                 sliver_widget_map[SliverToBoxAdapter(
//                     key: ObjectKey(objectType),
//                     child: Container(
//                         padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                         height: 50,
//                         alignment: Alignment.centerLeft,
//                         child: Text(intl.toBeginningOfSentenceCase(objectType)!,
//                             style: Theme.of(context).textTheme.headline1),
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.grey,
//                                     width: 1.0)))))] = SliverGrid(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2),
//                     delegate: SliverChildListDelegate.fixed(new_list_widget));
//               }
//             });
//           }
//           sliver_widget_map.forEach((key, value) {
//             widget_list.add(key);
//             widget_list.add(value);
//           });

//           return loadingState
//               ? Center(child: CircularProgressIndicator())
//               : Container(
//                   color: Colors.white,
//                   child: CustomScrollView(
//                     slivers: widget_list,
//                   ));
//         },
//         error: (err, st) {
//           return Center(child: Text(err.toString()));
//         },
//         loading: () => Center(child: CircularProgressIndicator()));
//   }
// }

// class FolderListBuilder extends StatelessWidget {
//   const FolderListBuilder({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
