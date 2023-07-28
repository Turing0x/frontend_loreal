import 'package:frontend_loreal/utils_exports.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Map<String, dynamic> jwtAMap(String signature) {
  JWT jwt = JWT.verify(signature, SecretKey(dotenv.env['SECRETKEY_JWT']!));
  return jwt.payload;
}
