import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'dart:io' as io;

import 'package:imagedeletor/providers/permission_provider.dart';

class NewFolderFileWidget extends HookConsumerWidget {
  final String optVal;

  NewFolderFileWidget(this.optVal);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderPath = ref.watch(folderPathProvier);
    final controller = useTextEditingController();
    String filefolderName = optVal == "1" ? "Folder" : "File";

    return AlertDialog(
      title: Text("Create New ${filefolderName}"),
      content: TextField(
        controller: controller,
        decoration:
            InputDecoration(hintText: "Enter New ${filefolderName} Name"),
        onChanged: (value) {
          filefolderName = controller.text;
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

            optVal == "1"
                ? ref
                    .read(folderListAsyncProvider.notifier)
                    .addNewFolder("${folderPath}/${filefolderName}")
                : ref
                    .read(folderListAsyncProvider.notifier)
                    .addNewFile("${folderPath}/${filefolderName}");
            Navigator.pop(context);
          },
          child: Text("Save"),
        )
      ],
    );
  }
}
