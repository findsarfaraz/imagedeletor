import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imagedeletor/providers/generic_provider.dart';
import 'package:imagedeletor/screens/folder_list_screen.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          DrawerProfileSection(),
          // Divider(height: 2),
          InkWell(
              onTap: () async {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.home), title: Text('Home'))),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.clock), title: Text('Recent')),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.dumpster),
              title: Text('Recycle Bin')),
          // Divider(height: 2),
          ListTile(
              onTap: () async {
                // await ref
                //     .read(folderListAsyncProvider.notifier)
                //     .fetch('/storage/emulated/0');

                await ref
                    .read(folderPathStateNotifierProvider.notifier)
                    .updatePath('/storage/emulated/0');

                Navigator.of(context).pushNamed(FolderListScreen.routeName);
              },
              leading: FaIcon(FontAwesomeIcons.memory),
              title: Row(
                children: [
                  Text("Internal Storage"),
                  Expanded(child: Text("")),
                  Container(
                    color: Colors.black12,
                    height: 50,
                    width: 1,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      print('clicked on broom');
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: FaIcon(
                        FontAwesomeIcons.broom,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              )),
          Divider(height: 2),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.questionCircle),
              title: Text('Help & Feedback')),
        ],
      ),
    );
  }
}

class DrawerProfileSection extends StatelessWidget {
  const DrawerProfileSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 90,
      child: DrawerHeader(
          margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.amber,
                      ),
                    )),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 8,
                child: Container(
                  margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text('Sarfaraz Ahmed'),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed('/editprofilescreen'),
                            child: Container(
                              padding: EdgeInsets.all(3),
                              child: Text('EDIT',
                                  style: Theme.of(context).textTheme.headline2),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
