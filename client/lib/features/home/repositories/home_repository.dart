import 'package:client/core/constants/server_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:client/core/failure/failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/song_model.dart';
import 'dart:convert';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<Failure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/song/upload'),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath(
            'thumbnail',
            selectedThumbnail.path,
          ),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll({'x-auth-token': token});

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(Failure(message: await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e, stackTrace) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/song/list'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(Failure(message: resBodyMap['detail']));
      }

      List<SongModel> songs = [];
      resBodyMap = resBodyMap as List;
      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
