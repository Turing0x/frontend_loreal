import 'package:frontend_loreal/config/controllers/users_controller.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/server/http/methods.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:flutter/material.dart';

TextStyle? tituloListTile =
    const TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold);
TextStyle? subtituloListTile = const TextStyle(fontFamily: 'Dosis');

Divider divisor = const Divider(
  color: Colors.black,
  indent: 20,
  endIndent: 20,
);

PreferredSizeWidget? showAppBar(String titulo,
    {Widget? leading, List<Widget>? actions, bool centerTitle = true}) {
  return AppBar(
    title:
        textoDosis(titulo, 24, color: (isDark) ? Colors.black : Colors.white),
    elevation: 2,
    centerTitle: centerTitle,
    leading: leading,
    actions: actions,
  );
}

void showToast(BuildContext context, String msg, {bool type = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: (type) ? Colors.red : Colors.white,
  ));
}

Container btnWithIcon(BuildContext context, Color? backgroundColor, Widget icon,
    String texto, void Function()? onPressed, double width,
    {double fontSize = 20}) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    width: width,
    child: ElevatedButton.icon(
        icon: icon,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 2,
        ),
        label: textoDosis(texto, fontSize, color: Colors.white),
        onPressed: onPressed),
  );
}

Widget textoDosis(String texto, double? fontSize,
    {FontWeight? fontWeight = FontWeight.normal,
    TextAlign? textAlign = TextAlign.left,
    Color? color = Colors.black,
    int? maxLines,
    bool underline = false}) {
  return Text(
    texto,
    overflow: TextOverflow.ellipsis,
    maxLines: maxLines,
    style: TextStyle(
      decoration: (underline) ? TextDecoration.underline : null,
      fontFamily: 'Dosis',
      color: (isDark) ? Colors.white : color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}

Widget boldLabel(String texto, String another, double? fontSize,
    {Color? color = Colors.black}) {
  return RichText(
    text: TextSpan(
      // Here is the explicit parent TextStyle
      style: TextStyle(
        fontSize: fontSize,
        color: (isDark) ? Colors.white : Colors.black,
        fontFamily: 'Dosis',
      ),
      children: <TextSpan>[
        TextSpan(
            text: texto, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: another),
      ],
    ),
  );
}

Padding dinamicGroupBox(String labelText, List<Widget> widgets,
    {double padding = 20}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: InputDecorator(
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(25)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: widgets),
    ),
  );
}

Future<dynamic> showInfoDialog(BuildContext context, String titulo,
    Widget content, void Function()? onPressed) {
  return showDialog(
    context: context,
    builder: (dialogContex) => AlertDialog(
      title: Text(titulo, style: tituloListTile),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      content: content,
      actions: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400], elevation: 2),
          icon: const Icon(Icons.cancel_outlined),
          label: const Text('Cancelar'),
          onPressed: () => Navigator.pop(dialogContex),
        ),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400], elevation: 2),
            icon: const Icon(Icons.thumb_up_outlined),
            label: const Text('Aceptar'),
            onPressed: onPressed),
      ],
    ),
  );
}

Object? mostrarDialogo(
  BuildContext context, {
  required String title,
  Color? colorFondoTitle,
  Widget? content,
  EdgeInsetsGeometry titlePadding = EdgeInsets.zero,
  double elevation = 2,
  ShapeBorder? shape,
  required String titleBoton,
  required void Function() onPressed,
  bool cerrarAutomatico = true,
  bool mostrarCancelar = true,
  Color? colorBoton,
  Widget? widgetTitle,
}) async {
  final result = await showDialog<Object>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: titlePadding,
        shape: shape,
        elevation: elevation,
        title: DecoratedBox(
          decoration: BoxDecoration(
            color: colorFondoTitle ?? Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textoDosis(
                  title,
                  20,
                ),
                if (widgetTitle != null) widgetTitle,
              ],
            ),
          ),
        ),
        content: content,
        actions: [
          Row(
            mainAxisAlignment: mostrarCancelar
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            children: [
              if (mostrarCancelar)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    elevation: 2,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: textoDosis('Cancelar', 20, color: Colors.white),
                ),
              if (mostrarCancelar)
                const SizedBox(
                  width: 10,
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  elevation: 2,
                ),
                onPressed: () {
                  onPressed.call();
                  if (cerrarAutomatico) Navigator.pop(context);
                },
                child: textoDosis(titleBoton, 20, color: Colors.white),
              ),
            ],
          )
        ],
      );
    },
  );
  return result;
}

RoundedRectangleBorder shape({
  double? radius,
  Color colorBorder = Colors.transparent,
  double widthBorde = 1,
}) {
  return RoundedRectangleBorder(
    side: BorderSide(
      color: colorBorder,
      width: widthBorde,
    ),
    borderRadius: borderRadius(radius: radius),
  );
}

BorderRadius borderRadius({double? radius}) {
  return BorderRadius.circular(radius ?? 12);
}

Container containerRayaDebajo({required Widget child}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black)),
    ),
    width: double.infinity,
    child: child,
  );
}

ElevatedButton cerrarSesionWidget(BuildContext context) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: (isDark) ? Colors.black87 : Colors.red[100],
      elevation: 2,
    ),
    label: textoDosis('Cerrar sesión', 20),
    icon: Icon(
      Icons.logout_outlined,
      color: (isDark) ? Colors.white : Colors.black,
    ),
    onPressed: () async {
      await cerrarSesion(context);
    },
  );
}

Padding toChangePass(BuildContext context) {
  TextEditingController actualPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  final userCtrl = UserControllers();

  return dinamicGroupBox('Cambiar clave de acceso', [
    TxtInfo(
      texto: 'Clave actual: ',
      keyboardType: TextInputType.text,
      controlador: actualPass,
      icon: Icons.lock_outline_rounded,
      onChange: (valor) => (() {}),
      left: 5,
      right: 5,
    ),
    TxtInfo(
      texto: 'Nueva clave: ',
      keyboardType: TextInputType.text,
      controlador: newPass,
      icon: Icons.password,
      onChange: (valor) => (() {}),
      left: 5,
      right: 5,
    ),
    const SizedBox(height: 10),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            elevation: 2,
          ),
          child: textoDosis('Cambiar clave', 20, color: Colors.white),
          onPressed: () =>
              userCtrl.changePass(actualPass.text, newPass.text, context)),
    ),
  ]);
}

ElevatedButton botonElevado({
  Color? backgroundColor,
  Color? disabledBackgroundColor,
  Color? colorText,
  Color? disabledForegroundColor,
  double width = double.infinity,
  double height = 40,
  double radius = 30,
  void Function()? onPressed,
  double fontSize = 14,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  required String title,
  EdgeInsetsGeometry? padding,
  double? elevation,
  FontWeight fontWeight = FontWeight.bold,
  bool isToUpperCase = true,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: botonEstilo(
      backgroundColor: backgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      colorText: colorText,
      disabledForegroundColor: disabledForegroundColor,
      width: width,
      height: height,
      radius: radius,
      padding: padding,
      elevation: elevation,
    ),
    child: textoDosis(
      title,
      fontSize,
      fontWeight: fontWeight,
      color: onPressed == null ? disabledForegroundColor : colorText,
    ),
  );
}

ButtonStyle botonEstilo({
  Color? backgroundColor,
  Color? disabledBackgroundColor,
  Color? colorText,
  Color? disabledForegroundColor,
  double width = double.infinity,
  double height = 40,
  double radius = 30,
  EdgeInsetsGeometry? padding,
  double? elevation,
  AlignmentGeometry? alignment,
}) {
  return ElevatedButton.styleFrom(
    elevation: elevation,
    minimumSize: Size(width, height),
    padding: padding,
    backgroundColor: backgroundColor,
    foregroundColor: colorText,
    disabledForegroundColor: disabledForegroundColor,
    disabledBackgroundColor: disabledBackgroundColor ?? Colors.grey.shade300,
    alignment: alignment,
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
    shape: shape(radius: radius),
  );
}
