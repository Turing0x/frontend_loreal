import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parles_model.g.dart';

@JsonSerializable()
class ParlesModel {
  final String uuid;
  final List<String> numplay;
  final int fijo;
  final int dinero;

  ParlesModel({
    required this.uuid,
    required this.numplay,
    required this.fijo,
    required this.dinero,
  });

  ParlesModel.fromTextEditingController(
    this.dinero, {
    required this.uuid,
    required String numplay,
    required String numplay1,
    required String fijo,
  })  : numplay = '$numplay\n$numplay1'.split('\n').map((e) => e).toList(),
        fijo = fijo.intTryParsed ?? 0;

  @override
  String toString() {
    return {
      'uuid': uuid,
      'numplay': numplay,
      'fijo': fijo,
      'dinero': 0,
    }.toString();
  }

  factory ParlesModel.fromJson(Map<String, dynamic> json) =>
      _$ParlesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParlesModelToJson(this);
}

class ParlesList {
  final List<ParlesModel> list;

  ParlesList({
    required this.list,
  });

  ParlesList.fromList(List<dynamic> json)
      : list = json.map((e) => ParlesModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() => list.map((e) => e.toJson()).toList();
}
