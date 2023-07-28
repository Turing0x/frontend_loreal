// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TerminalModel _$TerminalModelFromJson(Map<String, dynamic> json) =>
    TerminalModel(
      uuid: json['uuid'],
      terminal: json['terminal'] as int,
      corrido: json['corrido'] as int,
      fijo: json['fijo'] as int,
      dinero: json['dinero'] as int,
    );

Map<String, dynamic> _$TerminalModelToJson(TerminalModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'terminal': instance.terminal,
      'fijo': instance.fijo,
      'corrido': instance.corrido,
      'dinero': instance.dinero,
    };
