import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:ui';
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../model/song_model.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final res = await ref
      .watch(homeRepositoryProvider)
      .getAllSongs(token: ref.read(currentUserProvider)!.token!);

  return res.fold((l) => throw Exception(l.message), (r) => r);
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue<String?> build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);

    return const AsyncValue.data(null);
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserProvider)!.token!,
    );

    final val = res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }

  List<SongModel> getRecetnlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }
}
