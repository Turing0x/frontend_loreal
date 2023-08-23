import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/methods/update_methods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/design/Release/change_log_widget.dart';
import 'package:frontend_loreal/models/Release/release_model.dart';
import 'package:github/github.dart';
import 'package:r_upgrade/r_upgrade.dart';

class ReleaseStep1 extends ConsumerStatefulWidget {
  const ReleaseStep1({
    super.key,
    required this.releaseAsset,
  });
  final ReleaseModel releaseAsset;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReleaseStep1State();
}

class _ReleaseStep1State extends ConsumerState<ReleaseStep1> {
  ReleaseAsset? asset;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.releaseAsset.isDownloading()) {
        buscarActualizacionMethod(ref);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final releaseAsset = ref.watch(release);
    if (releaseAsset.isDownloading()) {
      return actualizar(
        asset: asset,
        context: context,
        ref: ref,
        body: releaseAsset.body(),
      );
    }
    if (releaseAsset.buscandoRelease) {
      return const CircularProgressIndicator();
    }
    asset = releaseAsset.buscarMaximaVersionRelease();
    return FutureBuilder<bool>(
      key: Key(DateTime.now().toString()),
      future: releaseAsset.isSuperiorVersion(asset),
      builder: (_, snapshotBool) {
        if (!snapshotBool.hasData) {
          return const CircularProgressIndicator();
        }
        if (!snapshotBool.data!) {
          return textoDosis('No hay nuevas versiones', 13);
        }
        return actualizar(
          asset: asset,
          context: context,
          ref: ref,
          body: releaseAsset.body(),
        );
      },
    );
  }

  Widget actualizar({
    required ReleaseAsset? asset,
    required BuildContext context,
    required WidgetRef ref,
    required String body,
  }) {
    final releaseAsset = ref.watch(release);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Flexible(child: FlutterLogo(size: 30)),
                Flexible(
                  flex: 2,
                  child: boldLabel('Versión: ',
                      asset?.name != null ? asset!.name!.version : '-', 20),
                ),
                Flexible(
                  child:
                      releaseAsset.info.status != DownloadStatus.STATUS_RUNNING
                          ? Icon(
                              Icons.download,
                              color: Theme.of(context).primaryColor,
                            )
                          : textoDosis(
                              '${releaseAsset.info.percent!.round()}%', 13),
                ),
              ],
            ),
          ),
          onTap: () => ref.read(release.notifier).actualizarState(
                step: 2,
              ),
        ),
        ChangeLogWidget(body: body),
      ],
    );
  }
}
