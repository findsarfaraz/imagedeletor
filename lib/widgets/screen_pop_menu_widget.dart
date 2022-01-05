import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'dart:io' as io;

import 'package:imagedeletor/providers/permission_provider.dart';

class NewFolderFileWidget extends HookConsumerWidget {
  NewFolderFileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderPath = ref.watch(folderPathProvier);
    final controller = useTextEditingController();
    String folderName = "New folder";

    void saveFolder() async {
      await io.Directory(folderPath + '/' + folderName).create(recursive: true);
    }

    return AlertDialog(
      title: Text("Create New file"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: "Enter File Name"),
        onChanged: (value) {
          folderName = controller.text;
        },
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        MaterialButton(
          onPressed: () {
            ref
                .read(devicePermissionProvider.notifier)
                .getExternalStoragePermission();
            saveFolder();
            Navigator.pop(context);
          },
          child: Text("Save"),
        )
      ],
    );
  }
}
