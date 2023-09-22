// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'centenas_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CentenasModel _$CentenasModelFromJson(Map<String, dynamic> json) =>
    CentenasModel(
      uuid: json['uuid'],
      numplay: json['numplay'],
      fijo: json['fijo'] as int,
      dinero: json['dinero'] as int,
    );

Map<String, dynamic> _$CentenasModelToJson(CentenasModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'numplay': instance.numplay,
      'fijo': instance.fijo,
      'dinero': instance.dinero,
    };
