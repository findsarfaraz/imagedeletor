import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/editprofilescreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: Center(
          child: Text('Edit Profile'),
        ));
  }
}
