class FolderListModel {
  String folderFileName;
  String folderPath;
  String folderAbsolutePath;
  double folderSize;
  String type;
  DateTime changeDate;
  DateTime accessDate;
  DateTime modifiedDate;
  String fileExtension;
  String parentFolder;
  bool selected;
  FolderListModel(
      {required this.folderFileName,
      required this.folderPath,
      required this.folderAbsolutePath,
      required this.folderSize,
      required this.type,
      required this.changeDate,
      required this.accessDate,
      required this.modifiedDate,
      required this.fileExtension,
      required this.parentFolder,
      required this.selected});
}
