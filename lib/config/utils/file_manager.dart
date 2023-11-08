// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:path_provider/path_provider.dart';

Future<File> fileManagerWriteGlobal(final mapAsString) async {
  final file = await localFiletoBlockIfOutOfLimit;
  final contenidoJsonString = jsonEncode(mapAsString);

  return file.writeAsString(contenidoJsonString);
}

Future<File> fileManagerWriteFCPC(final mapAsString) async {
  final file = await localFiletoBlockIfOutOfLimitFCPC;
  final contenidoJsonString = jsonEncode(mapAsString);

  return file.writeAsString(contenidoJsonString);
}

Future<File> fileManagerWriteTerminal(final mapAsString) async {
  final file = await localFiletoBlockIfOutOfLimitTerminal;
  final contenidoJsonString = jsonEncode(mapAsString);

  return file.writeAsString(contenidoJsonString);
}

Future<File> fileManagerWriteDecena(final mapAsString) async {
  final file = await localFiletoBlockIfOutOfLimitDecena;
  final contenidoJsonString = jsonEncode(mapAsString);

  return file.writeAsString(contenidoJsonString);
}

Future readAllFilesAndSaveInMaps() async {
  try {
    final readFiletoBlockIfOutOfLimit = await localFiletoBlockIfOutOfLimit;
    final readFiletoBlockIfOutOfLimitFCPC =
        await localFiletoBlockIfOutOfLimitFCPC;
    final readFiletoBlockIfOutOfLimitTerminal =
        await localFiletoBlockIfOutOfLimitTerminal;
    final readFiletoBlockIfOutOfLimitDecena =
        await localFiletoBlockIfOutOfLimitDecena;

    if (readFiletoBlockIfOutOfLimit.existsSync()) {
      String contentsFTBIOL = await readFiletoBlockIfOutOfLimit.readAsString();
      jsonDecode(contentsFTBIOL).forEach((key, value) {
        toBlockIfOutOfLimit[key] = value as int;
      });
    }

    if (readFiletoBlockIfOutOfLimitFCPC.existsSync()) {
      String contentsFTBIOLFCPC =
          await readFiletoBlockIfOutOfLimitFCPC.readAsString();

      jsonDecode(contentsFTBIOLFCPC).forEach((key, value) {
        Map<String, int> innerMap = {};
        value.forEach((innerKey, innerValue) {
          innerMap[innerKey] = innerValue as int;
        });
        toBlockIfOutOfLimitFCPC[key] = innerMap;
      });
    }

    if (readFiletoBlockIfOutOfLimitTerminal.existsSync()) {
      String contentsFTBIOLT =
          await readFiletoBlockIfOutOfLimitTerminal.readAsString();

      jsonDecode(contentsFTBIOLT).forEach((key, value) {
        Map<String, int> innerMap = {};
        value.forEach((innerKey, innerValue) {
          innerMap[innerKey] = innerValue as int;
        });
        toBlockIfOutOfLimitTerminal[key] = innerMap;
      });
    }
    if (readFiletoBlockIfOutOfLimitDecena.existsSync()) {
      String contentsFTBIOLD =
          await readFiletoBlockIfOutOfLimitDecena.readAsString();

      jsonDecode(contentsFTBIOLD).forEach((key, value) {
        Map<String, int> innerMap = {};
        value.forEach((innerKey, innerValue) {
          innerMap[innerKey] = innerValue as int;
        });
        toBlockIfOutOfLimitDecena[key] = innerMap;
      });
    }
  } catch (e) {
    print('Todo mal');
  }
}

Future deleteAllFiles() async {
  try {
    final readFiletoBlockIfOutOfLimit = await localFiletoBlockIfOutOfLimit;
    final readFiletoBlockIfOutOfLimitFCPC =
        await localFiletoBlockIfOutOfLimitFCPC;
    final readFiletoBlockIfOutOfLimitTerminal =
        await localFiletoBlockIfOutOfLimitTerminal;
    final readFiletoBlockIfOutOfLimitDecena =
        await localFiletoBlockIfOutOfLimitDecena;

    if( readFiletoBlockIfOutOfLimit.existsSync() ) readFiletoBlockIfOutOfLimit.deleteSync();
    if( readFiletoBlockIfOutOfLimitFCPC.existsSync() ) readFiletoBlockIfOutOfLimitFCPC.deleteSync();
    if( readFiletoBlockIfOutOfLimitTerminal.existsSync() ) readFiletoBlockIfOutOfLimitTerminal.deleteSync();
    if( readFiletoBlockIfOutOfLimitDecena.existsSync() ) readFiletoBlockIfOutOfLimitDecena.deleteSync();
    
  } catch (e) {
    print('nada');
  }
}

Future<File> get localFiletoBlockIfOutOfLimit async {
  final path = await localPath;
  return File('$path/toBlockIfOutOfLimit.txt');
}

Future<File> get localFiletoBlockIfOutOfLimitFCPC async {
  final path = await localPath;
  return File('$path/toBlockIfOutOfLimitFCPC.txt');
}

Future<File> get localFiletoBlockIfOutOfLimitTerminal async {
  final path = await localPath;
  return File('$path/toBlockIfOutOfLimitTerminal.txt');
}

Future<File> get localFiletoBlockIfOutOfLimitDecena async {
  final path = await localPath;
  return File('$path/toBlockIfOutOfLimitDecena.txt');
}

Future<String> get localPath async {
  Directory? appDocDirectory = await getExternalStorageDirectory();
  final directory = await Directory('${appDocDirectory?.path}/$globalUserName')
      .create(recursive: true);

  return directory.path;
}
