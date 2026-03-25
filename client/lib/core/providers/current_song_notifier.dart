import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:audio_service/audio_service.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer ??= AudioPlayer()
      ..playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          this.state = this.state?.copyWith(isPlaying: false);
        }
      });

    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id.toString(),
        title: song.song_name,
        artist: song.artist ?? 'Unknown Artist',
        artUri: song.thumbnail_url != null
            ? Uri.parse(song.thumbnail_url!)
            : null,
      ),
    );

    // ✅ DO NOT call stop()
    await audioPlayer!.setAudioSource(audioSource);

    await audioPlayer!.play();

    _homeLocalRepository.uploadLocalSong(song);

    state = song.copyWith(isPlaying: true);
  }

  void togglePlayPause() {
    if (audioPlayer == null || state == null) return;

    if (state!.isPlaying) {
      audioPlayer!.pause();
    } else {
      audioPlayer!.play();
    }

    // ✅ update state (this triggers UI rebuild)
    state = state!.copyWith(isPlaying: !state!.isPlaying);
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (audioPlayer!.duration!.inMilliseconds * val).round(),
      ),
    );
  }
}
