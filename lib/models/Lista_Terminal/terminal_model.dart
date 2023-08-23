import 'package:json_annotation/json_annotation.dart';

part 'terminal_model.g.dart';

@JsonSerializable()
class TerminalModel {

  final String uuid;
  final int terminal;
  final int fijo;
  final int corrido;
  final int dinero;

  TerminalModel({
    required this.uuid,
    required this.terminal,
    required this.corrido,
    required this.fijo,
    required this.dinero,
  });

  @override
  String toString() {
    return {
      'uuid': uuid,
      'terminal': terminal,
      'corrido': corrido,
      'fijo': fijo,
      'dinero': dinero,
    }.toString();
  }

factory TerminalModel.fromJson(Map<String, dynamic> json) =>
      _$TerminalModelFromJson(json);

  Map<String, dynamic> toJson() => _$TerminalModelToJson(this);
}


class TerminalList{
  final List<TerminalModel> list;

  TerminalList({
    required this.list,
  });

  TerminalList.fromList(List<dynamic> json)
      : list = json.map((e) => TerminalModel.fromJson(e)).toList();

  List<Map<String, dynamic>> toList() =>
      list.map((e) => e.toJson()).toList();
}