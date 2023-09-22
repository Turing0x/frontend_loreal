import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
      required this.id,
      required this.enable,
      required this.username,
      required this.role,
      required this.owner,
      required this.calcs,
  });

  String id;
  bool enable;
  String username;
  dynamic role;
  dynamic owner;
  Object calcs;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'] ?? '',
      enable: json['enable'] ?? true,
      username: json['username'] ?? '',
      role: json['role'] ?? {},
      owner: json['owner'] ?? {},
      calcs: json['calcs'] ?? {
        'bruto': 0,
        'limpio': 0,
        'premio': 0,
        'perdido': 0,
        'ganado': 0
      },
  );

  Map<String, dynamic> toJson() => {
      'id': id,
      'enable': enable,
      'username': username,
      'role': role,
      'owner': owner,
      'calcs': calcs,
  };
}
