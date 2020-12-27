import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      centerTitle: true,
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
      textTheme: TextTheme(
          headline6: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      )),
      brightness: Brightness.light,
      elevation: 4,
    ),
  );
}
