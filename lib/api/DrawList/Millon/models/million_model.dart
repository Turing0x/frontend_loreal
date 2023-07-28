import 'package:json_annotation/json_annotation.dart';

part 'million_model.g.dart';

@JsonSerializable()
class MillionModel {

  final String uuid;
  final String numplay;
  final int fijo;
  final int corrido;
  final int dinero;

  MillionModel({
    required this.uuid,
    required this.numplay,
    required this.fijo,
    required this.corrido,
    required this.dinero,
  });

  @override
  String toString() {
    return {
      'uuid': uuid,
      'numplay': numplay,
      'corrido': fijo,
      'fijo': corrido,
      'dinero': dinero,
    }.toString();
  }

factory MillionModel.fromJson(Map<String, dynamic> json) =>
      _$MillionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MillionModelToJson(this);
}


class MillionList{
  final List<MillionModel> list;

  MillionList({
    required this.list,
  });

  MillionList.fromList(List<dynamic> json)
      : list = json.map((e) => MillionModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() =>
      list.map((e) => e.toJson()).toList();
}