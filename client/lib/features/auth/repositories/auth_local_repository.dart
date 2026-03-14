import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_local_repository.g.dart';

@riverpod
Future<AuthLocalRepository> authLocalRepository(Ref ref) async {
  final repo = AuthLocalRepository();
  await repo.init(); // init SharedPreferences automatically
  return repo;
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
