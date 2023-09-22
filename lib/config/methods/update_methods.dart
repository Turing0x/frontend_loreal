import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend_loreal/config/const/update_const.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:github/github.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:version/version.dart';

Future<PackageInfo> getAppVersion() async => PackageInfo.fromPlatform();

Future<Release>? checkRelease() {
  try {
    final github = GitHub(
      auth: const Authentication.withToken(tokenGithub),
    );
    return github.repositories
        .getLatestRelease(
          RepositorySlug(usernameConst, projectNameConst),
        )
        .catchError((e) async => Release())
        .timeout(const Duration(seconds: 10));
  } catch (_) {
    return null;
  }
}

Future<int?> download({
  required int? idAsset,
  required String? nameApp,
}) async {
  if (!await permissionStorage() || idAsset == null) {
    return null;
  }
  return RUpgrade.upgrade(
    'https://api.github.com/repos/$usernameConst/$projectNameConst/releases/assets/$idAsset',
    header: {
      'Accept': 'application/octet-stream',
      'User-Agent': 'Senscloud/${(await getAppVersion()).version}',
      'Authorization': 'Token $tokenGithub',
    },
    fileName: nameApp,
  );
}

Future<bool> permissionStorage() async {
  if (await Permission.storage.request().isGranted) {
    return true;
  }
  return await Permission.storage.request().isGranted;
}

Future<Iterable<MapEntry<dynamic, dynamic>>> changeLog(
  String body, {
  Version? actual,
}) async {
  if (body.isEmpty) return [];
  final versionActual =
      actual ?? Version.parse((await getAppVersion()).version);
  final json = jsonDecode(body) as Map;
  return json.entries
      .where(
        (element) =>
            Version.parse((element.key as String).quitarFecha) > versionActual,
      )
      .toList()
      .reversed;
}

bool borrarData(Iterable<MapEntry<dynamic, dynamic>> map) {
  return map.any(
    (element) =>
        element.key.toString().contains('*') ||
        element.value.toString().contains('*'),
  );
}

Future<void> buscarActualizacionMethod(
  WidgetRef ref,
) async {
  try {
    final estadoModificacion = ref.read(release.notifier)
      ..actualizarState(
        step: 1,
        buscandoRelease: true,
      );
    final releases = await checkRelease();
    estadoModificacion.actualizarState(
      buscandoRelease: false,
      release: releases,
      info: DownloadInfo(),
    );
  } on SocketException catch (e) {
    showToast('Ha ocurrido un error. $e');
  } on TimeoutException catch (e) {
    showToast('Ha ocurrido un error. $e');
  } on ReleaseNotFound catch (e) {
    showToast('Ha ocurrido un error. $e');
  }
}
