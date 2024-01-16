import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String accessToken = '';
String todayGlobal = DateFormat.MMMd().format(DateTime.now());
String jornalGlobal = (TimeOfDay.now().hour < 14) ? 'dia' : 'noche';
String globalUserName = '';
List<String> globallot = [];

bool isDark = false;