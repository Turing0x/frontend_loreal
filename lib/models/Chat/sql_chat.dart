class SQLChat {

  final String id;
  final String receiverID;
  final String receiver;

  SQLChat({
    required this.id,
    required this.receiverID,
    required this.receiver,
  });

  factory SQLChat.fromJson(Map<String, dynamic> json) => SQLChat(
    id: json["id"],
    receiverID: json["receiverID"],
    receiver: json["receiver"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "receiverID": receiverID,
    "receiver": receiver,
  };

}