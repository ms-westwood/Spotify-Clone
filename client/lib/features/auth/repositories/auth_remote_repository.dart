import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final user = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      print("Signup success");
      print(user);
      return user;
    } else {
      throw Exception(user['detail']);
    }
  }

  Future<void> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("Login success");
      print(data);
    } else {
      throw Exception(data['detail']);
    }
  }
}
