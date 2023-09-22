import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Release/release_model.dart';
import 'package:github/github.dart';
import 'package:r_upgrade/r_upgrade.dart';

class ReleaseRiverpod extends StateNotifier<ReleaseModel> {
  ReleaseRiverpod() : super(ReleaseModel());

  void actualizarState({
    DownloadInfo? info,
    Release? release,
    int? step,
    bool? buscandoRelease,
  }) {
    state = state.copyWith(
      info: info,
      release: release,
      step: step,
      buscandoRelease: buscandoRelease,
    );
  }
}
