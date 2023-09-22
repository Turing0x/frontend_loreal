import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTxt extends StatefulWidget {
  final TextEditingController controlador;
  final TextInputType keyboardType;
  final Function(String?) onChange;
  final Color? color;
  final IconData? icon;
  final String texto;
  final double left;
  final double right;
  final double top;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const SimpleTxt({
    Key? key,
    required this.keyboardType,
    required this.controlador,
    required this.onChange,
    required this.color,
    required this.icon,
    required this.texto,
    this.obscureText = false,
    this.left = 30,
    this.right = 30,
    this.top = 10,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<SimpleTxt> createState() => _SimpleTxtState();
}

class _SimpleTxtState extends State<SimpleTxt> {
  bool _changeColor = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: widget.left, right: widget.right, top: widget.top),
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
              obscureText: widget.obscureText,
              controller: widget.controlador,
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChange,
              style: const TextStyle(fontFamily: 'Dosis', fontSize: 20),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(widget.icon,
                      color: _changeColor ? Colors.blue : Colors.black),
                  focusedBorder: InputBorder.none,
                  counterText: '',
                  border: InputBorder.none,
                  hintText: widget.texto),
            ),
          ),
        ),
      ),
    );
  }
}