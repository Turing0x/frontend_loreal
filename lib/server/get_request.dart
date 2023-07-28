import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  Future<dynamic> getData(String url, [Map<String, String>? headers]) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    final parsedResponse = json.decode(response.body);
    return parsedResponse;
  }
}