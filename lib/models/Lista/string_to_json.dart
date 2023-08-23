import 'dart:convert';

ListStringToJson listStringToJsonFromJson(String str) => ListStringToJson.fromJson(json.decode(str));

String listStringToJsonToJson(ListStringToJson data) => json.encode(data.toJson());

class ListStringToJson {
    ListStringToJson({
        required this.mainList,
        required this.candado,
        required this.millon,
        required this.terminal,
        required this.numplay,
        required this.posicion,
    });

    MainList mainList;
    Candado candado;
    Millon millon;
    Decena terminal;
    Decena numplay;
    Decena posicion;

    factory ListStringToJson.fromJson(Map<String, dynamic> json) => ListStringToJson(
        mainList: MainList.fromJson(json['mainList']),
        candado: Candado.fromJson(json['candado']),
        millon: Millon.fromJson(json['millon']),
        terminal: Decena.fromJson(json['terminal']),
        numplay: Decena.fromJson(json['numplay']),
        posicion: Decena.fromJson(json['posicion']),
    );

    Map<String, dynamic> toJson() => {
        'mainList': mainList.toJson(),
        'candado': candado.toJson(),
        'millon': millon.toJson(),
        'terminal': terminal.toJson(),
        'numplay': numplay.toJson(),
        'posicion': posicion.toJson(),
    };
}

class Candado {
    Candado({
        required this.numeros,
        required this.apuesta,
    });

    List<dynamic> numeros;
    List<dynamic> apuesta;

    factory Candado.fromJson(Map<String, dynamic> json) => Candado(
        numeros: List<dynamic>.from(json['numeros'].map((x) => x)),
        apuesta: List<dynamic>.from(json['apuesta'].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'numeros': List<dynamic>.from(numeros.map((x) => x)),
        'apuesta': List<dynamic>.from(apuesta.map((x) => x)),
    };
}

class Decena {
    Decena({
        required this.numero,
        required this.fijo,
        required this.corrido,
    });

    List<dynamic> numero;
    List<dynamic> fijo;
    List<dynamic> corrido;

    factory Decena.fromJson(Map<String, dynamic> json) => Decena(
        numero: List<dynamic>.from(json['numero'].map((x) => x)),
        fijo: List<dynamic>.from(json['fijo'].map((x) => x)),
        corrido: List<dynamic>.from(json['corrido'].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'numero': List<dynamic>.from(numero.map((x) => x)),
        'fijo': List<dynamic>.from(fijo.map((x) => x)),
        'corrido': List<dynamic>.from(corrido.map((x) => x)),
    };
}

class MainList {
    MainList({
        required this.fijoCorrido,
        required this.parles,
        required this.centenas,
    });

    List<dynamic> fijoCorrido;
    List<dynamic> parles;
    List<dynamic> centenas;

    factory MainList.fromJson(Map<String, dynamic> json) => MainList(
        fijoCorrido: List<dynamic>.from(json['fijoCorrido'].map((x) => x)),
        parles: List<dynamic>.from(json['parles'].map((x) => x)),
        centenas: List<dynamic>.from(json['centenas'].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'fijoCorrido': List<dynamic>.from(fijoCorrido.map((x) => x)),
        'parles': List<dynamic>.from(parles.map((x) => x)),
        'centenas': List<dynamic>.from(centenas.map((x) => x)),
    };
}

class Millon {
    Millon({
        required this.sorteo,
        required this.fijo,
        required this.corrido,
    });

    List<dynamic> sorteo;
    List<dynamic> fijo;
    List<dynamic> corrido;

    factory Millon.fromJson(Map<String, dynamic> json) => Millon(
        sorteo: List<dynamic>.from(json['sorteo'].map((x) => x)),
        fijo: List<dynamic>.from(json['fijo'].map((x) => x)),
        corrido: List<dynamic>.from(json['corrido'].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'sorteo': List<dynamic>.from(sorteo.map((x) => x)),
        'fijo': List<dynamic>.from(fijo.map((x) => x)),
        'corrido': List<dynamic>.from(corrido.map((x) => x)),
    };
}
