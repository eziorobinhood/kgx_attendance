import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceServices {
  Future<AttendanceApiResponse> apiCallAttendance(
      Map<String, dynamic> param) async {
    var url = Uri.parse('http://34.28.3.109:8080/attendance_in');
    var response = await http.post(url, body: param);
    var responsecode;
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);
    return AttendanceApiResponse(id: data["id"], error: data["error"]);
  }
}

class AttendanceApiResponse {
  final String? id;
  final String? error;

  AttendanceApiResponse({this.id, this.error});

  Object? get token => null;
}
