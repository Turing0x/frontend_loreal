import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  final String receiver;
  final String receiverUsername;
  final String sender;
  final String senderUsername;
  final Date date;
  final String text;
  final String messageType;

  ChatMessage({
    required this.receiver,
    required this.receiverUsername,
    required this.sender,
    required this.senderUsername,
    required this.date,
    required this.text,
    required this.messageType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    receiver: json["receiver"],
    receiverUsername: json["receiverUsername"],
    sender: json["sender"],
    senderUsername: json["senderUsername"],
    date: Date.fromJson(json["date"]),
    text: json["text"],
    messageType: json["messageType"],
  );

  Map<String, dynamic> toJson() => {
    "receiver": receiver,
    "receiverUsername": receiverUsername,
    "sender": sender,
    "senderUsername": senderUsername,
    "date": date.toJson(),
    "text": text,
    "messageType": messageType,
  };
}

class Date {
final String date;
final String time;

  Date({
    required this.date,
    required this.time,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "time": time,
  };
}
