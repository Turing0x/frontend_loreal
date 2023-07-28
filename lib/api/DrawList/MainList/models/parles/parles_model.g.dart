// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parles_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParlesModel _$ParlesModelFromJson(Map<String, dynamic> json) => ParlesModel(
      uuid: json['uuid'],
      numplay: (json['numplay'] as List<dynamic>).map((e) => e as String).toList(),
      fijo: json['fijo'] as int,
      dinero: json['dinero'] as int,
    );

Map<String, dynamic> _$ParlesModelToJson(ParlesModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'numplay': instance.numplay,
      'fijo': instance.fijo,
      'dinero': instance.dinero,
    };
