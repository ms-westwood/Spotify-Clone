import 'dart:convert';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ServerConstant.serverURL}/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final user = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      print("Signup success");
      print(user);
      return UserModel.fromMap(user);
    } else {
      throw Exception(user['detail']);
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ServerConstant.serverURL}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("Login success");
      print(data);
      return UserModel.fromMap(data);
    } else {
      throw Exception(data['detail']);
    }
  }
}
