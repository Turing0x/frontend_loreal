import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  final UserInfo receiver;
  final UserInfo sender;
  final Messages messages;

  ChatMessage({
    required this.receiver,
    required this.sender,
    required this.messages,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    receiver: UserInfo.fromJson(json["receiver"]),
    sender: UserInfo.fromJson(json["sender"]),
    messages: Messages.fromJson(json["messages"]),
  );

  Map<String, dynamic> toJson() => {
    "receiver": receiver.toJson(),
    "sender": sender.toJson(),
    "messages": messages.toJson(),
  };
}

class Messages {
  final String messageType;
  final Date date;
  final String msglist;

  Messages({
    required this.messageType,
    required this.date,
    required this.msglist,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    messageType: json["messageType"],
    date: Date.fromJson(json["date"]),
    msglist: json["msglist"],
  );

  Map<String, dynamic> toJson() => {
    "messageType": messageType,
    "date": date.toJson(),
    "msglist": msglist,
  };
}

class Date {
  final String time;
  final String date;

  Date({
    required this.time,
    required this.date,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
    time: json["time"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "date": date,
  };
}

class UserInfo {
  final String id;
  final String username;

  UserInfo({
    required this.id,
    required this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}
