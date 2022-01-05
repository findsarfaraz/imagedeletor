import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primary_color = Colors.blue;

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primary_color,
    ),
    textTheme: _lightScreenTextTheme,
    iconTheme: _lightScreenIconTheme,
    appBarTheme: _lightScreenAppBarTheme,
    primaryIconTheme: _lightScreenIconTheme,
    scaffoldBackgroundColor: Colors.white,
  );

  static final TextTheme _lightScreenTextTheme = TextTheme(
      headline1: GoogleFonts.roboto(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
      headline2: GoogleFonts.roboto(
          fontSize: 13, color: primary_color, fontWeight: FontWeight.w500),
      bodyText1: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
      bodyText2: GoogleFonts.roboto(fontSize: 12),
      headline3: GoogleFonts.roboto(
          fontSize: 12, color: Colors.grey[600]) //Popmenu text
      );

  static final IconThemeData _lightScreenIconTheme = IconThemeData(size: 25);

  static final TextTheme _buttonTextTheme =
      TextTheme(button: GoogleFonts.roboto(fontSize: 15, color: Colors.white));

  static final AppBarTheme _lightScreenAppBarTheme = AppBarTheme(
    iconTheme: IconThemeData(size: 25, color: Colors.white),
    actionsIconTheme: IconThemeData(size: 25.0, color: Colors.white),
  );
}
