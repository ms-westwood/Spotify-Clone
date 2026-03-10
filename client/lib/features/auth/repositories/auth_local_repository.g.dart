// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_local_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authLocalRepository)
final authLocalRepositoryProvider = AuthLocalRepositoryProvider._();

final class AuthLocalRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthLocalocalRepository>,
          AuthLocalocalRepository,
          FutureOr<AuthLocalocalRepository>
        >
    with
        $FutureModifier<AuthLocalocalRepository>,
        $FutureProvider<AuthLocalocalRepository> {
  AuthLocalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocalRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocalRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AuthLocalocalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthLocalocalRepository> create(Ref ref) {
    return authLocalRepository(ref);
  }
}

String _$authLocalRepositoryHash() =>
    r'2492b666316ef1dec400547fb38a2c1fa0698d39';
