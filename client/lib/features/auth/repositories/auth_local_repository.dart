import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_local_repository.g.dart';

@riverpod
Future<AuthLocalocalRepository> authLocalRepository(Ref ref) async {
  final repo = AuthLocalocalRepository();
  await repo.init(); // init SharedPreferences automatically
  return repo;
}

class AuthLocalocalRepository {
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
