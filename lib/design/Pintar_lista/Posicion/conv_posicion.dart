import 'package:frontend_loreal/models/Lista_Posicion/posicion_model.dart';

List<dynamic> convertirPayloadPosicion(String uuid, String numplay, int fijo,
    int corrido, int corrido2, int dinero) {
  try {
    final posicion = PosicionModel(
      uuid: uuid,
      numplay: numplay,
      fijo: fijo,
      corrido: corrido,
      corrido2: corrido2,
      dinero: dinero,
    );
    return [posicion];
  } catch (e) {
    return [];
  }
}
