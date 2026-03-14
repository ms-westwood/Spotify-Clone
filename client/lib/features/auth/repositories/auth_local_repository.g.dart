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
          AsyncValue<AuthLocalRepository>,
          AuthLocalRepository,
          FutureOr<AuthLocalRepository>
        >
    with
        $FutureModifier<AuthLocalRepository>,
        $FutureProvider<AuthLocalRepository> {
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
  $FutureProviderElement<AuthLocalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthLocalRepository> create(Ref ref) {
    return authLocalRepository(ref);
  }
}

String _$authLocalRepositoryHash() =>
    r'698586ce62585d300a4b8ae7ef6f685fedbb5a7b';
