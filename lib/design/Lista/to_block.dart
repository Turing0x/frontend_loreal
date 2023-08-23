import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToBlockAnyBtnProvider extends StateNotifier<ToBlockAnyBtnModel> {
  ToBlockAnyBtnProvider() : super(ToBlockAnyBtnModel());

  void changeAllBtnState() {
    state = ToBlockAnyBtnModel();
  }

  void actualizarState({
    bool? blockStateMain,
    bool? blockStateCandado,
    bool? blockStateTerminal,
    bool? blockStateMillion,
    bool? blockStateDecena,
    bool? blockStatePosicion,
  }) {
    state = state.copyWith(
      blockStateMain: blockStateMain ?? state.blockStateMain,
      blockStateCandado: blockStateCandado ?? state.blockStateCandado,
      blockStateTerminal: blockStateTerminal ?? state.blockStateTerminal,
      blockStateMillion: blockStateMillion ?? state.blockStateMillion,
      blockStateDecena: blockStateDecena ?? state.blockStateDecena,
      blockStatePosicion: blockStatePosicion ?? state.blockStatePosicion,
    );
  }
}

class ToBlockAnyBtnModel {
  final bool blockStateMain;
  final bool blockStateCandado;
  final bool blockStateTerminal;
  final bool blockStateMillion;
  final bool blockStateDecena;
  final bool blockStatePosicion;

  ToBlockAnyBtnModel({
    this.blockStateMain = false,
    this.blockStateCandado = false,
    this.blockStateTerminal = false,
    this.blockStateMillion = false,
    this.blockStateDecena = false,
    this.blockStatePosicion = false,
  });

  copyWith({
    bool? blockStateMain,
    bool? blockStateCandado,
    bool? blockStateTerminal,
    bool? blockStateMillion,
    bool? blockStateDecena,
    bool? blockStatePosicion,
  }) {
    return ToBlockAnyBtnModel(
      blockStateMain: blockStateMain ?? this.blockStateMain,
      blockStateCandado: blockStateCandado ?? this.blockStateCandado,
      blockStateTerminal: blockStateTerminal ?? this.blockStateTerminal,
      blockStateMillion: blockStateMillion ?? this.blockStateMillion,
      blockStateDecena: blockStateDecena ?? this.blockStateDecena,
      blockStatePosicion: blockStatePosicion ?? this.blockStatePosicion,
    );
  }
}
