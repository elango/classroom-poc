import 'package:dio/dio.dart';

class ApiService {
  static const endPoint = 'https://classroom.googleapis.com';
  Dio client = new Dio();
  String token = '';

  // Updating auth token for REST Call
  Future updateClientInfo(String token_) async {
    token = token_;
    client.options.baseUrl = endPoint;
    client.options.headers['Authorization'] = token_;
  }

  // Get Cource List
  Future<List<dynamic>> getCourseList() async {
    try {
      var response = await client.get('$endPoint/v1/courses');
      print(response);
      return response.data['courses'];
    } catch (e) {
      print(e.toString());
    }
  }

  // Create new course
  Future createNewCourse(String title) async {}
}
