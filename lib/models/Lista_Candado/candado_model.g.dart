// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candado_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CandadoModel _$CandadoModelFromJson(Map<String, dynamic> json) => CandadoModel(
      uuid: json['uuid'],
      numplay: json['numplay'] as List<dynamic>,
      fijo: json['fijo'] as int,
      dinero: json['dinero'] as int,
    );

Map<String, dynamic> _$CandadoModelToJson(CandadoModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'numplay': instance.numplay,
      'fijo': instance.fijo,
      'dinero': instance.dinero,
    };
