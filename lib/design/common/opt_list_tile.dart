import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

ListTile optListTile(IconData leading, String title, String subtitle,
    Function()? onTap, bool flecha,
    {Color? color = Colors.transparent}) {
  return ListTile(
    trailing: (flecha) ? const Icon(Icons.arrow_right_rounded) : null,
    subtitle: Text(
      subtitle,
      style: subtituloListTile,
    ),
    leading: Icon(
      leading,
    ),
    title: Text(title, style: tituloListTile),
    tileColor: color,
    minLeadingWidth: 20,
    onTap: onTap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
