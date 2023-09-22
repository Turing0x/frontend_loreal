import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/methods/update_methods.dart';
import 'package:github/github.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:version/version.dart';

class ReleaseModel {
  ReleaseModel({
    DownloadInfo? info,
    this.release,
    this.step = 1,
    this.buscandoRelease = false,
  }) : info = info ?? DownloadInfo();

  final DownloadInfo info;
  final Release? release;
  final int step;
  final bool buscandoRelease;

  ReleaseModel copyWith({
    DownloadInfo? info,
    Release? release,
    int? step,
    bool? buscandoRelease,
  }) =>
      ReleaseModel(
        info: info ?? this.info,
        step: step ?? this.step,
        release: release ?? this.release,
        buscandoRelease: buscandoRelease ?? this.buscandoRelease,
      );

  String descarga() {
    if (info.status == null || info.status == DownloadStatus.STATUS_PENDING) {
      return 'Pendiente...';
    }
    if (info.status == DownloadStatus.STATUS_PAUSED) {
      return 'Pausado';
    }
    if (info.status == DownloadStatus.STATUS_CANCEL) {
      return 'Cancelado';
    }
    if (info.status == DownloadStatus.STATUS_FAILED) {
      return 'Fallado';
    }
    if (info.status == DownloadStatus.STATUS_SUCCESSFUL) {
      return 'Completado';
    }
    return '${info.percent!.toStringAsFixed(0)}% de ${_size()}';
  }

  String _size() {
    final mb = info.maxLength! / 1024 / 1024;
    if (mb > 0) return '${mb.round()} MB';
    final kb = mb * 1024;
    return '${kb.round()} KB';
  }

  bool sePuedeInstalar() {
    if (info.status == DownloadStatus.STATUS_RUNNING ||
        info.status == DownloadStatus.STATUS_PENDING ||
        info.status == null) return false;
    return true;
  }

  bool mostrarCancelar() {
    if (info.status == DownloadStatus.STATUS_CANCEL ||
        info.status == DownloadStatus.STATUS_FAILED ||
        info.status == DownloadStatus.STATUS_SUCCESSFUL) return false;
    return true;
  }

  Future<bool> isSuperiorVersion(ReleaseAsset? assets) async {
    if (assets == null) return false;
    final versionActual = Version.parse((await getAppVersion()).version);
    final version = Version.parse(assets.name!.version);
    return version > versionActual;
  }

  ReleaseAsset? buscarMaximaVersionRelease() {
    if (release == null || release!.assets == null) return null;
    return release!.assets!.reduce(
      (value, element) => Version.parse(value.name!.version) >
              Version.parse(element.name!.version)
          ? value
          : element,
    );
  }

  bool isDownloading() {
    if (info.status != null &&
        info.status != DownloadStatus.STATUS_CANCEL &&
        info.status != DownloadStatus.STATUS_FAILED &&
        info.status != DownloadStatus.STATUS_SUCCESSFUL) {
      return true;
    }
    return false;
  }

  String body() {
    return release?.body ?? '';
  }
}
