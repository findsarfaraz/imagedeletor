import 'dart:io';
import 'package:flutter/material.dart';

class ImageList extends StatefulWidget {
  const ImageList({Key? key}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

Directory appDirectory = Directory('/storage/emulated/0');
Map<Directory, String> fullPath1 = {
  Directory('/storage/emulated/0'): 'Storage'
};

String get_file_name(String fullPath) {
  File file = File(fullPath);
  return file.path.split('/').last;
}

class _ImageListState extends State<ImageList> {
  @override
  Widget build(BuildContext context) {
    var imageList = appDirectory
        .listSync()
        .map((item) => item.path)
        // .where((item) => item.endsWith(".jpg"))
        .toList(growable: false);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              height: 75,
              child: Card(
                  child: Align(
                child: Text(
                  'Storage',
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.centerLeft,
              )),
            ))
          ],
        ),
        Expanded(
          child: GridView.builder(
              itemCount: imageList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 3.0 / 4.6),
              itemBuilder: (context, index) {
                return Container(
                    padding: EdgeInsets.all(3),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            appDirectory = Directory(imageList[index]);
                          });
                        },
                        child: Card(
                            child: Text(get_file_name(imageList[index])))));
              }),
        )
      ],
    );
  }
}
