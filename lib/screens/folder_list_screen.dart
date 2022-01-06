import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:imagedeletor/providers/folder_trackback_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'package:imagedeletor/widgets/drawer_widget.dart';
import 'package:imagedeletor/widgets/folder_grid_widget.dart';
import 'package:imagedeletor/widgets/folder_list_widget.dart';
import 'package:imagedeletor/widgets/popup_menu_widget.dart';
import 'package:imagedeletor/widgets/screen_pop_menu_widget.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    screenWidth = MediaQuery.of(context).size.width;

    screenHeight = MediaQuery.of(context).size.height;

    final providerMenuSettings = ref.watch(folderSettingNotifierProvider);

    final folderPath = ref.watch(folderPathProvier.state).state;

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
        appBar: AppBar(
          title:
              //  Text('Folder List'),
              listView ? Text('Folder List') : Text('Folder grid'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.ac_unit,
                  color: listView ? Colors.amber : Colors.white,
                )),
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
                  print(value.toString());

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
          ],
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
                : FolderGridWidget(),
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

class FolderTrackBackWidget extends ConsumerWidget {
  const FolderTrackBackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(folderTrackBackProvider);
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) {
          return Text(data[index].FolderName);
        });
  }
}
