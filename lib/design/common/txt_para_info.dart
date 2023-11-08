import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

class TxtInfo extends StatefulWidget {
  final TextEditingController controlador;
  final TextInputType keyboardType;
  final Function(String?) onChange;
  final Color? color;
  final IconData? icon;
  final String texto;
  final double left;
  final bool readOnly;
  final bool autofocus;
  final double right;
  final double top;
  final List<TextInputFormatter>? inputFormatters;

  const TxtInfo({
    Key? key,
    required this.keyboardType,
    required this.controlador,
    required this.onChange,
    required this.color,
    required this.icon,
    required this.texto,
    this.left = 30,
    this.readOnly = false,
    this.autofocus = false,
    this.right = 30,
    this.top = 10,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<TxtInfo> createState() => _TxtInfoState();
}

class _TxtInfoState extends State<TxtInfo> {
  bool _changeColor = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: widget.left, right: widget.right, top: widget.top),
      child: Row(
        children: [
          textoDosis(widget.texto, 20),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: widget.color, borderRadius: BorderRadius.circular(10)),
              child: FocusScope(
                child: Focus(
                  onFocusChange: ((value) => setState(() {
                        _changeColor = value;
                      })),
                  child: TextField(
                    keyboardType: widget.keyboardType,
                    controller: widget.controlador,
                    onChanged: widget.onChange,
                    readOnly: widget.readOnly,
                    autofocus: widget.autofocus,
                    style: const TextStyle(fontFamily: 'Dosis', fontSize: 20),
                    inputFormatters: widget.inputFormatters,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(widget.icon,
                          color: _changeColor ? Colors.blue : Colors.black),
                      focusedBorder: InputBorder.none,
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}