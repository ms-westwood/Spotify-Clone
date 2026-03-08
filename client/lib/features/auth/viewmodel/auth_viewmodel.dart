import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/user_model.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    return null;
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final res = await _authRemoteRepository.signup(
        name: name,
        email: email,
        password: password,
      );
      print(res);
      state = AsyncValue.data(res);
    } catch (e, st) {
      print("Signup error: $e");
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = const AsyncValue.loading();
      final res = await _authRemoteRepository.login(
        email: email,
        password: password,
      );
      print(res);
      state = AsyncValue.data(res);
    } catch (e, st) {
      print("Login error: $e");
      state = AsyncValue.error(e, st);
    }
  }
}
