// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decena_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DecenaModel _$DecenaModelFromJson(Map<String, dynamic> json) => DecenaModel(
      uuid: json['uuid'],
      numplay: json['numplay'] as int,
      corrido: json['corrido'] as int,
      fijo: json['fijo'] as int,
      dinero: json['dinero'] as int,
    );

Map<String, dynamic> _$DecenaModelToJson(DecenaModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'numplay': instance.numplay,
      'fijo': instance.fijo,
      'corrido': instance.corrido,
      'dinero': instance.dinero,
    };
