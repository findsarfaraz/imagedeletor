import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/providers/folder_copy_paste_function_provider.dart';

import 'dart:io' as io;

import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';

class PopupMenuFunctionWidget extends ConsumerWidget {
  String path;
  String type;

  PopupMenuFunctionWidget(this.path, this.type);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        onSelected: (value) {
          bool confirmation = false;
          if (value == 7) {
            if (type.toLowerCase() == "directory") {
              TextButton yesButton = TextButton(
                  onPressed: () {
                    ref
                        .read(folderListAsyncProvider.notifier)
                        .deleteFileFolder(path, type);
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes"));
              TextButton noButton = TextButton(
                  onPressed: () {
                    confirmation = false;
                    Navigator.of(context).pop();
                  },
                  child: Text("No`"));
              AlertDialog alert = AlertDialog(
                  actions: [yesButton, noButton],
                  title: Text("Do you want to delete"));
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  });
            } else if (type.toLowerCase() == "file") {
              ref
                  .read(folderListAsyncProvider.notifier)
                  .deleteFileFolder(path, type);
            }
          } else if (value == 6) {
            io.FileSystemEntity fileSystemEntity;
            final folderPath = ref.read(folderPathStateProvider);
            if (type == "file") {
              fileSystemEntity = io.File(path);
            } else {
              fileSystemEntity = io.Directory(path);
            }
            ref.read(folderCopyStateProvider.state).state = fileSystemEntity;
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Rename"),
                value: 1,
              ),
              PopupMenuItem(
                child: Text("Zip"),
                value: 2,
              ),
              PopupMenuItem(
                child: Text("Favorite"),
                value: 3,
              ),
              PopupMenuItem(
                child: Text("Create shortcut"),
                value: 4,
              ),
              PopupMenuItem(
                child: Text("Cut"),
                value: 5,
              ),
              PopupMenuItem(
                child: Text("Copy"),
                value: 6,
              ),
              PopupMenuItem(
                child: Text("Delete"),
                value: 7,
              ),
              PopupMenuItem(
                child: Text("Properties"),
                value: 8,
              )
            ]);
  }
}
