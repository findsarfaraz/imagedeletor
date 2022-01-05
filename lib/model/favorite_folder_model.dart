import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();
const FaIcon testIcon = FaIcon(FontAwesomeIcons.accessibleIcon);

class FavoriteFolderModel {
  FavoriteFolderModel(
      {required this.folderName,
      required this.folderPath,
      required this.folder_icon,
      this.status = false,
      folder_id})
      : folder_id = folder_id ?? _uuid.v4();

  String folderName;
  String folderPath;
  bool status;
  String folder_id;
  FaIcon folder_icon;
}
