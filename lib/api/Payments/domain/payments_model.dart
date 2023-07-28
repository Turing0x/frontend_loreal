import 'dart:convert';

Payments paymentsFromJson(String str) => Payments.fromJson(json.decode(str));

String paymentsToJson(Payments data) => json.encode(data.toJson());

class Payments {
    Payments({
        required this.id,
        required this.pagosMillonCorrido,
        required this.pagosJugadaCorrido,
        required this.pagosJugadaCentena,
        required this.pagosJugadaParle,
        required this.pagosMillonFijo,
        required this.pagosJugadaFijo,
        required this.limitadosCorrido,
        required this.limitadosParle,
        required this.limitadosFijo,
        required this.parleListero,
        required this.bolaListero,
        required this.exprense,
    });

    String id;
    int pagosMillonCorrido;
    int pagosJugadaCorrido;
    int pagosJugadaCentena;
    int pagosMillonFijo;
    int pagosJugadaParle;
    int limitadosCorrido;
    int pagosJugadaFijo;
    int limitadosParle;
    int limitadosFijo;
    int parleListero;
    int bolaListero;
    int exprense;

    factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        id: json['_id'],
        pagosJugadaCorrido: json['pagos_jugada_Corrido'] ?? 0,
        pagosJugadaCentena: json['pagos_jugada_Centena'] ?? 0,
        pagosJugadaParle: json['pagos_jugada_Parle'] ?? 0,
        pagosJugadaFijo: json['pagos_jugada_Fijo'] ?? 0,
        pagosMillonCorrido: json['pagos_millon_Corrido'] ?? 0,
        pagosMillonFijo: json['pagos_millon_Fijo'] ?? 0,
        limitadosCorrido: json['limitados_Corrido'] ?? 0,
        limitadosParle: json['limitados_Parle'] ?? 0,
        limitadosFijo: json['limitados_Fijo'] ?? 0,
        parleListero: json['parle_listero'] ?? 0,
        bolaListero: json['bola_listero'] ?? 0,
        exprense: json['exprense'] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        '_id': id,
        'pagos_jugada_Corrido': pagosJugadaCorrido,
        'pagos_jugada_Centena': pagosJugadaCentena,
        'pagos_jugada_Parle': pagosJugadaParle,
        'pagos_jugada_Fijo': pagosJugadaFijo,
        'pagos_millon_Corrido': pagosMillonCorrido,
        'pagos_millon_Fijo': pagosMillonFijo,
        'limitados_Corrido': limitadosCorrido,
        'limitados_Parle': limitadosParle,
        'limitados_Fijo': limitadosFijo,
        'parle_listero': parleListero,
        'bola_listero': bolaListero,
        'exprense': exprense,
    };
}
