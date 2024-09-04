import 'package:frontend_loreal/models/Lista_Candado/candado_model.dart';

List<dynamic> convertirPayloadCandado(
    String uuid, List<dynamic> numplay, int fijo, int dinero) {
  try {
    final candado = CandadoModel(
      uuid: uuid,
      numplay: numplay,
      fijo: fijo,
      dinero: dinero,
    );

    return [candado];
  } catch (e) {
    return [];
  }
}
