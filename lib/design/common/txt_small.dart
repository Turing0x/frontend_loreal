import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TxtInfoSmall extends StatelessWidget {
  final TextEditingController controlador;
  final TextInputType keyboardType;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoFocus;
  final FocusNode focusNode;
  final Function(String?) onChange;

  const TxtInfoSmall({
    super.key,
    this.maxLength,
    required this.keyboardType,
    required this.controlador,
    required this.focusNode,
    required this.hintText,
    required this.onChange,
    this.maxLines,
    this.validator,
    this.inputFormatters,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      child: TextField(
        controller: controlador,
        keyboardType: keyboardType,
        maxLength: maxLength,
        autofocus: autoFocus,
        focusNode: focusNode,
        minLines: 1,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        textAlign: TextAlign.center,
        decoration: InputDecoration(hintText: hintText, counterText: ''),
        cursorColor: Colors.black,
        onChanged: onChange,
      ),
    );
  }
}
