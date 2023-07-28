import 'package:json_annotation/json_annotation.dart';
part 'decena_model.g.dart';

@JsonSerializable()
class DecenaModel {

  final String uuid;
  final int numplay;
  final int fijo;
  final int corrido;
  final int dinero;

  DecenaModel({
    required this.uuid,
    required this.numplay,
    required this.corrido,
    required this.fijo,
    required this.dinero,
  });

  @override
  String toString() {
    return {
      'uuid': uuid,
      'numplay': numplay,
      'corrido': corrido,
      'fijo': fijo,
      'dinero': dinero,
    }.toString();
  }

factory DecenaModel.fromJson(Map<String, dynamic> json) =>
      _$DecenaModelFromJson(json);

  Map<String, dynamic> toJson() => _$DecenaModelToJson(this);
}


class DecenaList{
  final List<DecenaModel> list;

  DecenaList({
    required this.list,
  });

  DecenaList.fromList(List<dynamic> json)
      : list = json.map((e) => DecenaModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() =>
      list.map((e) => e.toJson()).toList();
}