import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoriteFolderWidget extends StatelessWidget {
  final String folderName;
  final FaIcon folder_icon;

  FavoriteFolderWidget(this.folderName, this.folder_icon);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Row(children: [
      SizedBox(width: 15),
      folder_icon,
      SizedBox(width: 30),
      Text(folderName)
    ])));
  }
}
