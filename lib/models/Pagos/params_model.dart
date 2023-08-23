// To parse this JSON data, do
//
//     final params = paramsFromJson(jsonString);

import 'dart:convert';

Params paramsFromJson(String str) => Params.fromJson(json.decode(str));

String paramsToJson(Params data) => json.encode(data.toJson());

class Params {
    Params({
      required this.id,
      required this.limiteApuestasFijo,
      required this.limiteApuestasCorrido,
      required this.limiteApuestasParle,
      required this.limiteApuestasCentena,
      required this.limitadosFcDia,
      required this.limitadosFcNoche,
      required this.limitadosPDia,
      required this.limitadosPNoche,
      required this.premiosPor1Fijo,
      required this.premiosPor1Corrido,
      required this.premiosPor1Parle,
      required this.premiosPor1Centena,
      required this.premiosLimitados1Fijo,
      required this.premiosLimitados1Corrido,
      required this.premiosLimitados1Parle,
      required this.premiosLimitados1Centena,
      required this.gananciasFijo,
      required this.gananciasCorrido,
      required this.gananciasParle,
      required this.gananciasCentena,
    });

    String id;
    String limiteApuestasFijo;
    String limiteApuestasCorrido;
    String limiteApuestasParle;
    String limiteApuestasCentena;
    String limitadosFcDia;
    String limitadosFcNoche;
    String limitadosPDia;
    String limitadosPNoche;
    String premiosPor1Fijo;
    String premiosPor1Corrido;
    String premiosPor1Parle;
    String premiosPor1Centena;
    String premiosLimitados1Fijo;
    String premiosLimitados1Corrido;
    String premiosLimitados1Parle;
    String premiosLimitados1Centena;
    String gananciasFijo;
    String gananciasCorrido;
    String gananciasParle;
    String gananciasCentena;

    factory Params.fromJson(Map<String, dynamic> json) => Params(
      id: json['_id'],
      limiteApuestasFijo: json['limiteApuestasFijo'],
      limiteApuestasCorrido: json['limiteApuestasCorrido'],
      limiteApuestasParle: json['limiteApuestasParle'],
      limiteApuestasCentena: json['limiteApuestasCentena'],
      limitadosFcDia: json['limitadosFcDia'],
      limitadosFcNoche: json['limitadosFcNoche'],
      limitadosPDia: json['limitadosPDia'],
      limitadosPNoche: json['limitadosPNoche'],
      premiosPor1Fijo: json['premiosPor1Fijo'],
      premiosPor1Corrido: json['premiosPor1Corrido'],
      premiosPor1Parle: json['premiosPor1Parle'],
      premiosPor1Centena: json['premiosPor1Centena'],
      premiosLimitados1Fijo: json['premiosLimitados1Fijo'],
      premiosLimitados1Corrido: json['premiosLimitados1Corrido'],
      premiosLimitados1Parle: json['premiosLimitados1Parle'],
      premiosLimitados1Centena: json['premiosLimitados1Centena'],
      gananciasFijo: json['gananciasFijo'],
      gananciasCorrido: json['gananciasCorrido'],
      gananciasParle: json['gananciasParle'],
      gananciasCentena: json['gananciasCentena'],
    );

    Map<String, dynamic> toJson() => {
      '_id': id,
      'limiteApuestasFijo': limiteApuestasFijo,
      'limiteApuestasCorrido': limiteApuestasCorrido,
      'limiteApuestasParle': limiteApuestasParle,
      'limiteApuestasCentena': limiteApuestasCentena,
      'limitadosFcDia': limitadosFcDia,
      'limitadosFcNoche': limitadosFcNoche,
      'limitadosPDia': limitadosPDia,
      'limitadosPNoche': limitadosPNoche,
      'premiosPor1Fijo': premiosPor1Fijo,
      'premiosPor1Corrido': premiosPor1Corrido,
      'premiosPor1Parle': premiosPor1Parle,
      'premiosPor1Centena': premiosPor1Centena,
      'premiosLimitados1Fijo': premiosLimitados1Fijo,
      'premiosLimitados1Corrido': premiosLimitados1Corrido,
      'premiosLimitados1Parle': premiosLimitados1Parle,
      'premiosLimitados1Centena': premiosLimitados1Centena,
      'gananciasFijo': gananciasFijo,
      'gananciasCorrido': gananciasCorrido,
      'gananciasParle': gananciasParle,
      'gananciasCentena': gananciasCentena,
    };
}
