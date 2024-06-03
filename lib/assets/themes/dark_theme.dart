import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black87,
    actionsIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 2
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) => Colors.blueGrey),
      iconColor: WidgetStateProperty.resolveWith<Color>(
        (states) => Colors.white)
      )
  ),
  iconButtonTheme: IconButtonThemeData(style: ButtonStyle(iconColor: WidgetStateProperty.resolveWith<Color>(
      (states) => Colors.white))),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueGrey,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle(iconColor: WidgetStateProperty.resolveWith<Color>(
      (states) => Colors.black)))
);