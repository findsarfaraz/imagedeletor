import 'package:flutter/material.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);
  static const routeName = '/loadScreen';

  @override
  Widget build(BuildContext context) {
    List listColor = [Color.fromRGBO(148, 0, 211, 1)];
    return Scaffold(
        body: Center(child: CircularProgressIndicator(color: listColor[0])));
  }
}
