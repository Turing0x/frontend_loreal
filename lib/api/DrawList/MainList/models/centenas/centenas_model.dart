import 'package:frontend_loreal/extensions/string_extensions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'centenas_model.g.dart';

@JsonSerializable()
class CentenasModel {
  final String uuid;
  final String numplay;
  final int fijo;
  final int dinero;

  CentenasModel({
    required this.uuid,
    required this.numplay,
    required this.fijo,
    required this.dinero,
  });

  CentenasModel.fromTextEditingController(
    this.dinero, {
    required this.uuid,
    required String numplay1,
    required String fijo,
  })  : numplay = numplay1,
        fijo = fijo.intParsed;

  @override
  String toString() {
    return {
      'uuid': uuid,
      'numplay': numplay,
      'fijo': fijo,
      'dinero': 0,
    }.toString();
  }

  factory CentenasModel.fromJson(Map<String, dynamic> json) =>
      _$CentenasModelFromJson(json);

  Map<String, dynamic> toJson() => _$CentenasModelToJson(this);
}

class CentenasList {
  final List<CentenasModel> list;

  CentenasList({
    required this.list,
  });

  CentenasList.fromList(List<dynamic> json)
      : list = json.map((e) => CentenasModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() => list.map((e) => e.toJson()).toList();
}
