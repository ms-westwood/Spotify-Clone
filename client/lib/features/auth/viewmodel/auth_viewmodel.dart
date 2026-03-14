import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  AsyncValue<AuthLocalRepository>? _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserProvider.notifier);

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
      print("Attempting login with email: $email");
      state = const AsyncValue.loading();

      // await the provider directly, no intermediate field
      final localRepo = await ref.watch(authLocalRepositoryProvider.future);

      final user = await _authRemoteRepository.login(
        email: email,
        password: password,
      );
      //success
      print("Login successful, user: ${user.name}, token: ${user.token}");
      localRepo.setToken(user.token);
      _currentUserNotifier.addUser(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<UserModel?> getData() async {
    try {
      state = const AsyncValue.loading();

      final localRepo = await ref.watch(authLocalRepositoryProvider.future);
      final token = localRepo.getToken();

      if (token == null) {
        return null;
      }
      // Success
      final user = await _authRemoteRepository.getCurrentUserData(token: token);
      _currentUserNotifier.addUser(user);
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
