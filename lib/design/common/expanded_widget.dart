import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:frontend_loreal/config/methods/methods.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

class ExpandedWidget extends StatelessWidget {
  const ExpandedWidget({
    super.key,
    required this.title,
    required this.content,
    required this.controller,
    this.icono = Icons.description_outlined,
  });
  final String title;
  final Widget content;
  final ExpandedTileController controller;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      key: UniqueKey(),
      theme: const ExpandedTileThemeData(
        headerPadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        contentBackgroundColor: Colors.transparent,
        headerColor: Colors.transparent,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black,
      ),
      content: content,
      title: textoDosis(title, 13),
      onTap: () => toggleExpandedTile(controller),
      controller: controller,
    );
  }
}
