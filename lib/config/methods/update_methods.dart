import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

Future<bool> permissionStorage() async {
  if (await Permission.storage.request().isGranted) {
    return true;
  }
  return await Permission.storage.request().isGranted;
}
