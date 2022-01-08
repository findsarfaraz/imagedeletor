class MiscFunction {
  String get_folder_name(String path) {
    try {
      final String reverse_path = path.split('').reversed.join();
      final String folder_name =
          reverse_path.substring(0, reverse_path.indexOf('/'));
      // print(folder_name.split('').reversed.join());
      return folder_name.split('').reversed.join();
    } catch (e) {
      return "ERROR GET_FOLDER_NAME: ${e.toString()}";
    }
  }

  String get_file_extension(String path) {
    String folder_name;
    try {
      if (path.indexOf('.') != -1) {
        final String reverse_path = path.split('').reversed.join();
        folder_name = reverse_path.substring(0, reverse_path.indexOf('.'));
        return folder_name.split('').reversed.join();
      } else {
        return 'unk';
      }
    } catch (e) {
      print("ERROR GET_FILE_EXTENSION: ${e.toString()} ");
      return "ERROR GET_FILE_EXTENSION: ${e.toString()} ";
    }
  }
}
