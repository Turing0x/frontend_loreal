// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'million_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MillionModel _$MillionModelFromJson(Map<String, dynamic> json) => MillionModel(
      uuid: json['uuid'] as String,
      numplay: json['numplay'] as String,
      fijo: json['fijo'] as int,
      corrido: json['corrido'] as int,
      dinero: json['dinero'] as int,
    );

Map<String, dynamic> _$MillionModelToJson(MillionModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'numplay': instance.numplay,
      'fijo': instance.fijo,
      'corrido': instance.corrido,
      'dinero': instance.dinero,
    };
