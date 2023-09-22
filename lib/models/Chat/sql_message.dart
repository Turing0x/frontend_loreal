class SQLMessage {

  final String id;
  final String text;

  SQLMessage({
    required this.id,
    required this.text,
  });

  factory SQLMessage.fromJson(Map<String, dynamic> json) => SQLMessage(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };

}