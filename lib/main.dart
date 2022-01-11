import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imagedeletor/Theme/apptheme.dart';
import 'package:imagedeletor/providers/disk_info_provider.dart';
import 'package:imagedeletor/providers/favorite_folder_provider.dart';
import 'package:imagedeletor/providers/permission_provider.dart';
import 'package:imagedeletor/screens/edit_profile_screen.dart';
import 'package:imagedeletor/screens/favorite_folder_screen.dart';
import 'package:imagedeletor/screens/folder_list_screen.dart';

// import 'listimagescreen.dart';
import 'body.dart';
import 'widgets/drawer_widget.dart';
import 'widgets/loader_screen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      title: 'PicMan',
      home: MyHomePage(),
      routes: {
        MyHomePage.routeName: (ctx) => MyHomePage(),
        BodyScreen.routeName: (ctx) => BodyScreen(),
        LoaderScreen.routeName: (ctx) => LoaderScreen(),
        FavoriteFolderScreen.routeName: (ctx) => FavoriteFolderScreen(),
        EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
        FolderListScreen.routeName: (ctx) => FolderListScreen(),
      },
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  static final routeName = "myhomepage";
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const platform = MethodChannel("samples.flutter.dev/battery");

getInitialPermission() async {
  await platform.invokeMethod("getPermission");
}

getInitialPermissionrResult() async {
  await platform.invokeMethod("onActivityResult");
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // getInitialPermission();
    ref.read(devicePermissionProvider.notifier).getPermission();

    ref.read(homeScreenNotifierProvider.notifier).getSizeForNotifier();
    ref.read(favoritefolderNotifierProvider.notifier).getFolderForNotifier();
  }

  @override
  Widget build(BuildContext context) {
    // context.read(homeScreenNotifierProvider.notifier).getSizeForNotifier();

    Future<void> getBatteryFlutterLevel() async {
      String batteryLevel;
      try {
        final int result = await platform.invokeMethod("getPermission");
        batteryLevel = 'Battery level at $result % .';
      } on PlatformException catch (e) {
        print("Try part ran");
        batteryLevel = "Failed to get battery level: '${e.message}'.";
      }
    }

    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Picture Manager'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.batteryThreeQuarters, size: 20)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/favoritefolderscreen');
              },
              icon: FaIcon(FontAwesomeIcons.cogs, size: 20))
        ],
      ),
      drawer: Container(
        child: DrawerWidget(),
      ),
      body: BodyScreen(),
    );
  }
}
