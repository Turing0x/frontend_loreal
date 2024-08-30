import 'package:sticker_maker/models/Lista_Decena/decena_model.dart';

List<dynamic> convertirPayloadDecena(
    String uuid, int numplay, int fijo, int corrido, int dinero) {
  try {
    final decena = DecenaModel(
      uuid: uuid,
      numplay: numplay,
      fijo: fijo,
      corrido: corrido,
      dinero: dinero,
    );
    return [decena];
  } catch (e) {
    return [];
  }
}
