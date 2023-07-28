import 'package:json_annotation/json_annotation.dart';

part 'candado_model.g.dart';

@JsonSerializable()
class CandadoModel {

  final String uuid;
  final List<dynamic> numplay;
  final int fijo;
  final int dinero;

  CandadoModel({
    required this.uuid,
    required this.numplay,
    required this.fijo,
    required this.dinero,
  });

  @override
  String toString() {
    return {
      'uuid': uuid,
      'numplay': numplay,
      'fijo': fijo,
      'dinero': dinero,
    }.toString();
  }

factory CandadoModel.fromJson(Map<String, dynamic> json) =>
      _$CandadoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CandadoModelToJson(this);
}


class CandadoList{
  final List<CandadoModel> list;

  CandadoList({
    required this.list,
  });

  CandadoList.fromList(List<dynamic> json)
      : list = json.map((e) => CandadoModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() =>
      list.map((e) => e.toJson()).toList();
}