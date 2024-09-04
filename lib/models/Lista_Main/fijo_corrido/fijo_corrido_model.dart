import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fijo_corrido_model.g.dart';

@JsonSerializable()
class FijoCorridoModel {
  final String uuid;
  final int numplay;
  final int? fijo;
  final int? corrido;
  final int? dinero;

  FijoCorridoModel({
    required this.uuid,
    required this.numplay,
    required this.fijo,
    required this.corrido,
    required this.dinero,
  });

  FijoCorridoModel.fromTextEditingController(this.dinero,
      {required this.uuid,
      required String numplay,
      required String fijo,
      required String corrido})
      : numplay = numplay.intTryParsed ?? 0,
        fijo = fijo.intTryParsed ?? 0,
        corrido = corrido.intTryParsed ?? 0;

  @override
  String toString() {
    return {
      'uuid': uuid,
      'numplay': numplay,
      'fijo': fijo,
      'corrido': corrido,
      'dinero': 0,
    }.toString();
  }

  factory FijoCorridoModel.fromJson(Map<String, dynamic> json) =>
      _$FijoCorridoModelFromJson(json);

  Map<String, dynamic> toJson() => _$FijoCorridoModelToJson(this);
}

class FijoCorridoList {
  final List<FijoCorridoModel> list;

  FijoCorridoList({
    required this.list,
  });

  FijoCorridoList.fromList(List<dynamic> json)
      : list = json.map((e) => FijoCorridoModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() => list.map((e) => e.toJson()).toList();
}
