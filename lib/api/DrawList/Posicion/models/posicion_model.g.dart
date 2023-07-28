// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posicion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosicionModel _$PosicionModelFromJson(Map<String, dynamic> json) =>
    PosicionModel(
      uuid: json['uuid'],
      numplay: json['numplay'] as int,
      corrido: json['corrido'] as int,
      corrido2: json['corrido2'] as int,
      fijo: json['fijo'] as int,
      dinero: json['dinero'] as int,
    );

Map<String, dynamic> _$PosicionModelToJson(PosicionModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'numplay': instance.numplay,
      'fijo': instance.fijo,
      'corrido': instance.corrido,
      'corrido2': instance.corrido2,
      'dinero': instance.dinero,
    };
