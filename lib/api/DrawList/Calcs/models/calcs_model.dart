import 'package:json_annotation/json_annotation.dart';

part 'calcs_model.g.dart';

@JsonSerializable()
class CalcsModel {
  final int bruto;
  final int? limpio;

  CalcsModel({
    required this.bruto,
    required this.limpio,
  });

  CalcsModel.fromOtherPages(
    { required this.bruto,
      required int this.limpio });

  @override
  String toString() {
    return {
      'bruto': bruto,
      'limpio': limpio,
    }.toString();
  }

  factory CalcsModel.fromJson(Map<String, dynamic> json) =>
      _$CalcsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalcsModelToJson(this);
}

class CalcsList {
  final List<CalcsModel> list;

  CalcsList({
    required this.list,
  });

  CalcsList.fromList(List<dynamic> json)
      : list = json.map((e) => CalcsModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() => list.map((e) => e.toJson()).toList();
}