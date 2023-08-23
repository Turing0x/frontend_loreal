import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

class PopupWidgetRelease extends StatelessWidget {
  const PopupWidgetRelease({
    super.key,
    this.radius,
    this.color,
    required this.items,
    this.onSelected,
    this.iconColor = Colors.white,
    this.icono,
    this.opacity = 1,
    this.enabled = true,
  });
  final double? radius;
  final Color? color;
  final Color iconColor;
  final List<PopupMenuEntry<String>> items;
  final void Function(String)? onSelected;
  final IconData? icono;
  final double opacity;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enabled: enabled,
      icon: Icon(
        icono ?? Icons.more_vert,
        color: enabled
            ? iconColor.withOpacity(opacity)
            : iconColor.withOpacity(opacity / 2),
      ),
      color: color,
      shape: shape(radius: radius),
      itemBuilder: (_) {
        return items;
      },
      onSelected: onSelected,
    );
  }
}
