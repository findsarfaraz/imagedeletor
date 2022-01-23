import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/misc_function.dart';
import 'package:imagedeletor/model/folder_list_model.dart';
import 'package:imagedeletor/providers/folder_copy_paste_function_provider.dart';
import 'package:imagedeletor/providers/folder_list_provider.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'package:imagedeletor/widgets/drawer_widget.dart';
import 'package:imagedeletor/widgets/folder_grid_widget.dart';
import 'package:imagedeletor/widgets/folder_list_widget.dart';
import 'package:imagedeletor/widgets/folder_trackback_widget.dart';
import 'package:imagedeletor/widgets/popup_menu_widget.dart';
import 'package:imagedeletor/widgets/screen_pop_menu_widget.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;

final func_list = MiscFunction();

class FolderListScreen extends HookConsumerWidget {
  static const routeName = '/folderlistscreen';
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  bool isMenuOpen = false;
  late OverlayEntry _overlayEntry;
  GlobalKey _iconButtonKey = GlobalKey(debugLabel: "Icon key");

  double buttonWidth = 0.0;
  double buttonHeight = 0.0;
  double buttonXCor = 0.0;
  double buttonYCor = 0.0;

  double menuLeft = 0.0;
  double menuTop = 0.0;

  double menuWidth = 200;
  double menuHeight = 400;
  bool listView = true;

  bool multiSelectMode = false;
  int selectedItemCount = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    screenWidth = MediaQuery.of(context).size.width;

    screenHeight = MediaQuery.of(context).size.height;
    List<Widget> actionButton = [];
    final copiedData = ref.watch(folderCopyProvider);
    final folderPath = ref.watch(folderPathProvider);
    final providerMenuSettings = ref.watch(folderSettingNotifierProvider);

    void closeMenu(AnimationController animationController) {
      isMenuOpen = !isMenuOpen;
      animationController.reverse().whenComplete(() => _overlayEntry.remove());
    }

    menuWidth = screenWidth * 0.9 > 450 ? 450 : screenWidth * 0.9;

    AnimationController _animationController = useAnimationController(
        duration: Duration(milliseconds: 100),
        lowerBound: 0,
        upperBound: menuHeight,
        initialValue: 0);

    void getobject() {
      RenderBox renderBox =
          _iconButtonKey.currentContext?.findRenderObject() as RenderBox;

      buttonWidth = renderBox.size.width;
      buttonHeight = renderBox.size.height;
      buttonXCor = renderBox.localToGlobal(Offset.zero).dx;
      buttonYCor = renderBox.localToGlobal(Offset.zero).dy;

      menuLeft = buttonXCor + buttonWidth - menuWidth;
      menuTop = buttonYCor + buttonHeight;
    }

    void openMenu(AnimationController animationController) {
      getobject();

      _overlayEntry = _overlayEntryBuilder(_animationController, closeMenu);
      _animationController.forward();
      Overlay.of(context)?.insert(_overlayEntry);
      isMenuOpen = !isMenuOpen;
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Consumer(builder: (context, ref, child) {
            final folderListData = ref.watch(folderStateProvider);

            final selectedItemCount = folderListData
                .whenData((value) => value
                    .where((element) => element.selected == true)
                    .toList()
                    .length)
                .value;
            return AppBar(
              title: selectedItemCount == 0
                  ? p.basename(folderPath) == "0"
                      ? Text("Internal")
                      : Text(p.basename(folderPath))
                  : Text("${selectedItemCount} Selected"),
              actions: selectedItemCount == 0
                  ? [
                      Visibility(
                        visible: !(copiedData.path == "storage/emulated/0"),
                        child: IconButton(
                            onPressed: () async {
                              await ref
                                  .read(folderListAsyncProvider.notifier)
                                  .pasteFileFolder(copiedData, folderPath);
                              ref.read(folderCopyStateProvider.state).state =
                                  io.Directory("storage/emulated/0");
                            },
                            icon: Icon(
                              Icons.paste,
                              color: Colors.white,
                            )),
                      ),
                      IconButton(
                          key: _iconButtonKey,
                          onPressed: () {
                            if (isMenuOpen) {
                              closeMenu(_animationController);
                            } else {
                              openMenu(_animationController);
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.chevronCircleDown,
                            color: Colors.white,
                          )),
                      PopupMenuButton(
                          onSelected: (value) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return NewFolderFileWidget(value.toString());
                                });
                          },
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {},
                                  child: Text("New Folder"),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  child: Text("New File"),
                                  value: 2,
                                )
                              ])
                    ]
                  : actionButton = [
                      IconButton(
                          onPressed: () {
                            print("Print copy");
                          },
                          icon: FaIcon(FontAwesomeIcons.copy)),
                      IconButton(
                          onPressed: () {
                            print("Print delete");
                          },
                          icon: FaIcon(FontAwesomeIcons.trashAlt))
                    ],
            );
          }),
        ),
        drawer: Container(
          child: DrawerWidget(),
        ),
        body: Column(children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: FolderTrackBackWidget(),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 2, spreadRadius: 1, color: Colors.grey)
              ]),
              width: double.infinity,
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 10,
              child: providerMenuSettings.menuSettings[0] == "1"
                  ? FolderListWidget()
                  : FolderListWidget()
              // FolderGridWidget(),
              ),
        ]));
  }

  OverlayEntry _overlayEntryBuilder(
      AnimationController animationController, Function closeMenu) {
    return OverlayEntry(builder: (builder) {
      return
          //  PopUpMenu();

          PopUpMenu(
              // getSettings: getSettings,
              closeMenu: closeMenu,
              buttonHeight: buttonHeight,
              menuHeight: menuHeight,
              menuLeft: menuLeft,
              menuTop: menuTop,
              menuWidth: menuWidth,
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              aniController: animationController,
              isMenuOpen: isMenuOpen);
    });
  }
}
