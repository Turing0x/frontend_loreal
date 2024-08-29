import 'package:local_auth/local_auth.dart';

Future<bool> hasBiometrics() async {
  final LocalAuthentication auth = LocalAuthentication();

  final isAvailable = await auth.canCheckBiometrics;
  final isDeviceSupported = await auth.isDeviceSupported();
  return isAvailable && isDeviceSupported;
}
