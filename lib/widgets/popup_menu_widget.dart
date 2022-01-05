import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/providers/folder_setting_provider.dart';
import 'package:imagedeletor/providers/generic_provider.dart';

class PopUpMenu extends StatelessWidget {
  // final Function getSettings;
  final Function closeMenu;
  final double menuLeft;
  final double menuTop;
  final double menuHeight;
  final double menuWidth;
  final double screenHeight;
  final double screenWidth;
  final double buttonHeight;
  final AnimationController aniController;
  final bool isMenuOpen;

  PopUpMenu(
      {Key? key,
      // required this.getSettings,
      required this.closeMenu,
      required this.menuLeft,
      required this.menuTop,
      required this.menuHeight,
      required this.menuWidth,
      required this.screenHeight,
      required this.screenWidth,
      required this.buttonHeight,
      required this.aniController,
      required this.isMenuOpen})
      : super(key: key);

  bool initLoad = false;
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    bool saveCheckBox = false;

    return Consumer(builder: (_, WidgetRef ref, __) {
      final folderPath = ref.watch(folderPathProvier);

      if (initLoad = false) {
        ref
            .read(folderSettingNotifierProvider.notifier)
            .initializeMenuSettings(folderPath);
        initLoad = true;
      }

      ref.listen(folderSettingNotifierProvider, (previous, next) {
        isChecked = true;
        saveCheckBox = true;
      });

      final providerMenuSettings = ref.watch(folderSettingNotifierProvider);

      return Positioned(
          left: 0,
          top: 0,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  closeMenu(aniController);
                },
                child: Container(
                  height: screenHeight - buttonHeight,
                  width: screenWidth,
                  color: Colors.white.withOpacity(0),
                ),
              ),
              Positioned(
                left: menuLeft,
                top: menuTop,
                child: Container(
                  height: 400.0,
                  width: menuWidth,
                  color: Colors.white,
                  child: Card(
                      elevation: 2,
                      child: Container(
                        child: Column(
                          children: [
                            Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            padding: EdgeInsets.fromLTRB(
                                                12, 0, 0, 0),
                                            child: Text(
                                              "View Mode",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 8,
                                          fit: FlexFit.loose,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  0);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .list,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[
                                                                            0] ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings
                                                                            .menuSettings[0] ==
                                                                        "1"
                                                                    ? Text(
                                                                        'List',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3,
                                                                      )
                                                                    : Text(
                                                                        'List',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  1);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .th,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[
                                                                            1] ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[
                                                                            1] ==
                                                                        "1"
                                                                    ? Text(
                                                                        'Grid',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(
                                                                                headline3: TextStyle(
                                                                                    color: Colors
                                                                                        .blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Grid',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 8,
                                                    fit: FlexFit.tight,
                                                    child: Container())
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 1,
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    color: Colors.grey[200],
                                  ),
                                )),
                            Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            padding: EdgeInsets.fromLTRB(
                                                12, 0, 0, 0),
                                            child: Text(
                                              "Sort by",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 8,
                                          fit: FlexFit.loose,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  2);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                providerMenuSettings.menuSettings[2] ==
                                                                            "1" ||
                                                                        providerMenuSettings.menuSettings[2] ==
                                                                            "0"
                                                                    ? FontAwesomeIcons
                                                                        .sortAlphaDown
                                                                    : FontAwesomeIcons
                                                                        .sortAlphaDownAlt,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[2] ==
                                                                            "1" ||
                                                                        providerMenuSettings.menuSettings[2] ==
                                                                            "2"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[2] ==
                                                                            "1" ||
                                                                        providerMenuSettings.menuSettings[2] ==
                                                                            "2"
                                                                    ? Text(
                                                                        'Name',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Name',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  3);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: providerMenuSettings.menuSettings[3] ==
                                                                              "1" ||
                                                                          providerMenuSettings.menuSettings[3] ==
                                                                              "0"
                                                                      ? Transform
                                                                          .rotate(
                                                                          angle: 90 *
                                                                              math.pi /
                                                                              180,
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.chartPie,
                                                                            size:
                                                                                20,
                                                                            color: providerMenuSettings.menuSettings[3] == "1" || providerMenuSettings.menuSettings[3] == "2"
                                                                                ? Colors.blue
                                                                                : Colors.grey[600],
                                                                          ),
                                                                        )
                                                                      : Transform
                                                                          .rotate(
                                                                          angle: 270 *
                                                                              math.pi /
                                                                              180,
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.chartPie,
                                                                            size:
                                                                                20,
                                                                            color: providerMenuSettings.menuSettings[3] == "1" || providerMenuSettings.menuSettings[3] == "2"
                                                                                ? Colors.blue
                                                                                : Colors.grey[600],
                                                                          ),
                                                                        )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[3] ==
                                                                            "1" ||
                                                                        providerMenuSettings.menuSettings[3] ==
                                                                            "2"
                                                                    ? Text(
                                                                        'Size',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Size',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  4);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: providerMenuSettings.menuSettings[4] ==
                                                                              "1" ||
                                                                          providerMenuSettings.menuSettings[4] ==
                                                                              "0"
                                                                      ? FaIcon(
                                                                          FontAwesomeIcons
                                                                              .tag,
                                                                          size:
                                                                              20,
                                                                          color: providerMenuSettings.menuSettings[4] == "1" || providerMenuSettings.menuSettings[4] == "2"
                                                                              ? Colors.blue
                                                                              : Colors.grey[600],
                                                                        )
                                                                      : Transform
                                                                          .rotate(
                                                                          angle: 180 *
                                                                              math.pi /
                                                                              180,
                                                                          child:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.tag,
                                                                            size:
                                                                                20,
                                                                            color: providerMenuSettings.menuSettings[4] == "1" || providerMenuSettings.menuSettings[4] == "2"
                                                                                ? Colors.blue
                                                                                : Colors.grey[600],
                                                                          ),
                                                                        )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[4] ==
                                                                            "1" ||
                                                                        providerMenuSettings.menuSettings[4] ==
                                                                            "2"
                                                                    ? Text(
                                                                        'Type',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Type',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  5);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: providerMenuSettings.menuSettings[5] ==
                                                                              "1" ||
                                                                          providerMenuSettings.menuSettings[5] ==
                                                                              "0"
                                                                      ? Transform.rotate(
                                                                          angle: 180 * math.pi / 180,
                                                                          child: FaIcon(
                                                                            FontAwesomeIcons.hourglassEnd,
                                                                            size:
                                                                                20,
                                                                            color: providerMenuSettings.menuSettings[5] == "1" || providerMenuSettings.menuSettings[5] == "2"
                                                                                ? Colors.blue
                                                                                : Colors.grey[600],
                                                                          ))
                                                                      : FaIcon(
                                                                          FontAwesomeIcons
                                                                              .hourglassEnd,
                                                                          size:
                                                                              20,
                                                                          color: providerMenuSettings.menuSettings[5] == "1" || providerMenuSettings.menuSettings[5] == "2"
                                                                              ? Colors.blue
                                                                              : Colors.grey[600],
                                                                        )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[5] ==
                                                                            "1" ||
                                                                        providerMenuSettings.menuSettings[5] ==
                                                                            "2"
                                                                    ? Text(
                                                                        'Date',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Date',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 4,
                                                    fit: FlexFit.tight,
                                                    child: Container())
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 1,
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    color: Colors.grey[200],
                                  ),
                                )),
                            Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            padding: EdgeInsets.fromLTRB(
                                                12, 0, 0, 0),
                                            child: Text(
                                              "Filter by",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 8,
                                          fit: FlexFit.loose,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  6);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .filter,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[
                                                                            6] ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[
                                                                            6] ==
                                                                        "1"
                                                                    ? Text(
                                                                        'Show All',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Show All',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  7);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .image,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[
                                                                            7] ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[
                                                                            7] ==
                                                                        "1"
                                                                    ? Text(
                                                                        'Picture',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Picture',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  8);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .video,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[
                                                                            8] ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[
                                                                            8] ==
                                                                        "1"
                                                                    ? Text(
                                                                        'Video',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Video',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  9);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .dochub,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[
                                                                            9] ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[
                                                                            9] ==
                                                                        "1"
                                                                    ? Text(
                                                                        'Document',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Document',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  providerSettingsForMenu
                                                                      .notifier)
                                                              .updateMenuSettings(
                                                                  10);
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .music,
                                                                size: 20,
                                                                color: providerMenuSettings.menuSettings[
                                                                            10] ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                              )),
                                                              Container(
                                                                child: providerMenuSettings.menuSettings[
                                                                            10] ==
                                                                        "1"
                                                                    ? Text(
                                                                        'Music',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .copyWith(headline3: TextStyle(color: Colors.blue))
                                                                            .headline3)
                                                                    : Text(
                                                                        'Music',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 1,
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    color: Colors.grey[200],
                                  ),
                                )),
                            Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: ListTile(
                                        title: isChecked
                                            ? Text(
                                                'Apply these changes to this Folder',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .copyWith(
                                                        headline3: TextStyle(
                                                            color: Colors
                                                                .grey[800],
                                                            fontSize: 12))
                                                    .headline3)
                                            : Text(
                                                'Apply these changes to this Folder',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                        trailing: isChecked
                                            ? Checkbox(
                                                onChanged: (newvalue) {
                                                  ref
                                                      .read(
                                                          folderSettingNotifierProvider
                                                              .notifier)
                                                      .saveMenuSettings(
                                                          folderPath);
                                                },
                                                value: true)
                                            : Checkbox(
                                                onChanged: null,
                                                value: false,
                                              )))),
                          ],
                        ),
                      )),
                ),
              )
            ],
          ));
    });
  }
}
