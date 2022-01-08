import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderPath extends StateNotifier<String> {
  FolderPath() : super("");

  Future<void> updatePath(String path) async {
    state = path;
  }
}
