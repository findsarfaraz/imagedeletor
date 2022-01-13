import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';

class FolderTrackBackWidget extends ConsumerWidget {
  const FolderTrackBackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data1 = ref.watch(folderTrackBackProvider);

    ScrollController scrollController = ScrollController();

    ref.listen(folderTrackBackProvider, (previous, next) {
      print("Ran listen");
      scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 50),
          curve: Curves.easeInOut);
    });

    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data1.length,
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            return Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () async {
                    await ref
                        .read(folderPathStateNotifierProvider.notifier)
                        .updatePath(data1[index].folderPath);
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Row(children: [
                        (index == 0 && data1[index].folderName == "0")
                            ? Container(
                                child: FaIcon(FontAwesomeIcons.mobileAlt,
                                    size: 18, color: Colors.grey[700]))
                            : Text(data1[index].folderName,
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        (255 /
                                                (index == 0 && data1.length > 0
                                                    ? 1
                                                    : data1.length - index))
                                            .floor(),
                                        0,
                                        0,
                                        0),
                                    fontSize: 16)),
                        data1.length > 1 && data1.length - index != 1
                            ? Container(
                                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: FaIcon(FontAwesomeIcons.angleRight,
                                    color: Colors.grey[700], size: 16))
                            : Container()
                      ])),
                ));
          }),
    );
  }
}
