import 'package:frontend_loreal/api/DrawList/Terminal/models/terminal_model.dart';

List<dynamic> convertirPayloadTerminales(
    String uuid, int numplay, int fijo, int corrido, int dinero) {
  try {
    final terminal = TerminalModel(
      uuid: uuid,
      terminal: numplay,
      fijo: fijo,
      corrido: corrido,
      dinero: dinero,
    );
    return [terminal];
  } catch (e) {
    return [];
  }
}
