import 'package:frontend_loreal/api/DrawList/Millon/models/million_model.dart';

List<dynamic> convertirPayloadMillon(
    String uuid, String numplay, int fijo, int corrido, int dinero) {
  try {
    final millon = MillionModel(
      uuid: uuid,
      numplay: numplay,
      fijo: fijo,
      corrido: corrido,
      dinero: dinero,
    );
    return [millon];
  } catch (e) {
    return [];
  }
}
