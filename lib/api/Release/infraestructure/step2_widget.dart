import 'package:frontend_loreal/api/Release/domain/release_model.dart';
import 'package:frontend_loreal/api/Release/infraestructure/change_log_widget.dart';
import 'package:frontend_loreal/const/update_const.dart';
import 'package:frontend_loreal/methods/update_methods.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github/github.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ReleaseStep2 extends ConsumerStatefulWidget {
  const ReleaseStep2({
    super.key,
    required this.estadoRelease,
  });
  final ReleaseModel estadoRelease;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReleaseStep2State();
}

class _ReleaseStep2State extends ConsumerState<ReleaseStep2> {
  late double tamLetra;
  ReleaseAsset? asset;

  @override
  void initState() {
    tamLetra = 15;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final releaseModel = ref.watch(release);
      if (!releaseModel.isDownloading()) {
        download(
          idAsset: asset!.id,
          nameApp: asset!.name,
        );
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    asset = ref.watch(release).buscarMaximaVersionRelease();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () =>
                  ref.read(release.notifier).actualizarState(step: 1),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: sliderCircular(
                innerWidget: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlutterLogo(),
                ),
                status: widget.estadoRelease.info.status,
                progress: widget.estadoRelease.info.percent ?? 0,
                spinnerMode: widget.estadoRelease.info.status !=
                        DownloadStatus.STATUS_RUNNING &&
                    widget.estadoRelease.info.status !=
                        DownloadStatus.STATUS_SUCCESSFUL,
                animationEnabled: widget.estadoRelease.info.status !=
                    DownloadStatus.STATUS_RUNNING,
              ),
            ),
            Flexible(
                child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  textoDosis(
                    '$releaseTagConst:',
                    tamLetra,
                  ),
                  textoDosis(
                    asset!.name ?? '-',
                    tamLetra,
                  ),
                  textoDosis(
                    widget.estadoRelease.descarga(),
                    tamLetra,
                    fontWeight: FontWeight.normal,
                  )
                ],
              ),
            )),
          ],
        ),
        Row(
          children: [
            if (widget.estadoRelease.mostrarCancelar())
              Flexible(
                child: botonElevado(
                  title: 'Cancelar',
                  onPressed: widget.estadoRelease.info.status ==
                          DownloadStatus.STATUS_RUNNING
                      ? () async => RUpgrade.cancel(
                            (await RUpgrade.getLastUpgradedId())!,
                          )
                      : null,
                ),
              ),
            const SizedBox(width: 10),
            Flexible(
              child: botonElevado(
                title: 'Instalar',
                onPressed: widget.estadoRelease.sePuedeInstalar()
                    ? () => download(
                          idAsset: asset!.id,
                          nameApp: asset!.name,
                        )
                    : null,
              ),
            ),
          ],
        ),
        ChangeLogWidget(body: widget.estadoRelease.body()),
      ],
    );
  }

  Widget sliderCircular({
    Widget? innerWidget,
    bool spinnerMode = false,
    required double progress,
    bool animationEnabled = true,
    required DownloadStatus? status,
  }) {
    return Stack(
      children: [
        SleekCircularSlider(
          key: UniqueKey(),
          initialValue: progress < 0 ? 0 : progress,
          innerWidget: innerWidget != null ? (_) => innerWidget : null,
          appearance: CircularSliderAppearance(
            animationEnabled: animationEnabled,
            size: 100,
            startAngle: 270,
            angleRange: 360,
            spinnerMode: spinnerMode,
            customColors: CustomSliderColors(
              progressBarColor: Colors.green,
              trackColor: Colors.green,
            ),
            customWidths: CustomSliderWidths(
              progressBarWidth: 4,
              trackWidth: 2,
            ),
          ),
        ),
        if (spinnerMode)
          const Positioned.fill(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: FlutterLogo(),
          )),
      ],
    );
  }
}
