import 'package:frontend_loreal/api/Release/infraestructure/step1_widget.dart';
import 'package:frontend_loreal/api/Release/infraestructure/step2_widget.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReleaseVersionsWidget extends ConsumerWidget {
  const ReleaseVersionsWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoRelease = ref.watch(release);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: estadoRelease.step == 1
          ? ReleaseStep1(
              releaseAsset: estadoRelease,
            )
          : ReleaseStep2(
              estadoRelease: estadoRelease,
            ),
    );
  }
}
