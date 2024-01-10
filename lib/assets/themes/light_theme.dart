import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    actionsIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 2
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => Colors.white),
      iconColor: MaterialStateProperty.resolveWith<Color>(
        (states) => Colors.white)
      )
  ),
  iconButtonTheme: IconButtonThemeData(style: ButtonStyle(iconColor: MaterialStateProperty.resolveWith<Color>(
      (states) => Colors.white))),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle(iconColor: MaterialStateProperty.resolveWith<Color>(
      (states) => Colors.black)))
);