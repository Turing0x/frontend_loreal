// To parse this JSON data, do
//
//     final millionGame = millionGameFromJson(jsonString);

import 'dart:convert';

MillionGame millionGameFromJson(String str) => MillionGame.fromJson(json.decode(str));

String millionGameToJson(MillionGame data) => json.encode(data.toJson());

class MillionGame {
  MillionGame({
    required this.owner,
    required this.date,
    required this.jornal,
    required this.millionPlay,
  });

  String owner;
  String date;
  String jornal;
  MillionPlay millionPlay;

  factory MillionGame.fromJson(Map<String, dynamic> json) => MillionGame(
    owner: json['owner'],
    date: json['date'],
    jornal: json['jornal'],
    millionPlay: MillionPlay.fromJson(json['millionPlay']),
  );

  Map<String, dynamic> toJson() => {
    'owner': owner,
    'date': date,
    'jornal': jornal,
    'millionPlay': millionPlay.toJson(),
  };
}

class MillionPlay {
  MillionPlay({
    required this.millionLot,
    required this.fijo,
    required this.corrido,
    required this.dinero,
  });

  String millionLot;
  int fijo;
  int corrido;
  int dinero;

  factory MillionPlay.fromJson(Map<String, dynamic> json) => MillionPlay(
    millionLot: json['millionLot'],
    fijo: json['fijo'],
    corrido: json['corrido'],
    dinero: json['dinero'],
  );

  Map<String, dynamic> toJson() => {
    'millionLot': millionLot,
    'fijo': fijo,
    'corrido': corrido,
    'dinero': dinero,
  };
}
