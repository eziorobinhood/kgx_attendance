// ignore: file_names
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  Future<LoginApiResponse> apiCallLogin(Map<String, dynamic> param) async {
    var url = Uri.parse('https://reqres.in/api/login');
    var response = await http.post(url, body: param);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);
    return LoginApiResponse(
        // access_token: data["access_token"],
        // token_type: data["token_type"],
        token: data["token"],
        error: data["error"]);
  }
}

class LoginApiResponse {
  final String? access_token;
  final String? token_type;
  final String? error;

  LoginApiResponse({
    this.access_token,
    this.token_type,
    this.error,
    required token,
  });

  Object? get token => null;
}
