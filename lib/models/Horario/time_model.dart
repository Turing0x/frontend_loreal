// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

Time timeFromJson(String str) => Time.fromJson(json.decode(str));

String timeToJson(Time data) => json.encode(data.toJson());

class Time {
    Time({
        required this.dayStart,
        required this.dayEnd,
        required this.nightStart,
        required this.nightEnd,
    });

    String dayStart;
    String dayEnd;
    String nightStart;
    String nightEnd;

    factory Time.fromJson(Map<String, dynamic> json) => Time(
        dayStart: json['dayStart'],
        dayEnd: json['dayEnd'],
        nightStart: json['nightStart'],
        nightEnd: json['nightEnd'],
    );

    Map<String, dynamic> toJson() => {
        'dayStart': dayStart,
        'dayEnd': dayEnd,
        'nightStart': nightStart,
        'nightEnd': nightEnd,
    };
}
