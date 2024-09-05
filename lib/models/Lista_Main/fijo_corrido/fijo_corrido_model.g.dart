// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fijo_corrido_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FijoCorridoModel _$FijoCorridoModelFromJson(Map<String, dynamic> json) =>
    FijoCorridoModel(
      uuid: json['uuid'] as String,
      numplay: json['numplay'].toString(),
      fijo: json['fijo'] as int?,
      corrido: json['corrido'] as int?,
      dinero: json['dinero'] as int?,
    );

Map<String, dynamic> _$FijoCorridoModelToJson(FijoCorridoModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'numplay': instance.numplay,
      'fijo': instance.fijo,
      'corrido': instance.corrido,
      'dinero': instance.dinero,
    };
