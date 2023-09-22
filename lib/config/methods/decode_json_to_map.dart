import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, dynamic> jwtAMap(String signature) {
  JWT jwt = JWT.verify(signature, SecretKey(dotenv.env['SECRETKEY_JWT']!));
  return jwt.payload;
}
