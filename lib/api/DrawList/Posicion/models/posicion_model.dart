import 'package:json_annotation/json_annotation.dart';

part 'posicion_model.g.dart';

@JsonSerializable()
class PosicionModel {

  final String uuid;
  final int numplay;
  final int fijo;
  final int corrido;
  final int corrido2;
  final int dinero;

  PosicionModel({
    required this.uuid,
    required this.numplay,
    required this.corrido,
    required this.corrido2,
    required this.fijo,
    required this.dinero,
  });

  @override
  String toString() {
    return {
      'uuid': uuid,
      'numplay': numplay,
      'corrido': corrido,
      'corrido2': corrido2,
      'fijo': fijo,
      'dinero': dinero,
    }.toString();
  }

factory PosicionModel.fromJson(Map<String, dynamic> json) =>
      _$PosicionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PosicionModelToJson(this);
}

class Posicion{
  final List<PosicionModel> list;

  Posicion({
    required this.list,
  });

  Posicion.fromList(List<dynamic> json)
      : list = json.map((e) => PosicionModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() =>
      list.map((e) => e.toJson()).toList();
}