import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';

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
    audioPlayer ??= AudioPlayer();

    final audioSource = AudioSource.uri(Uri.parse(song.song_url));
    await audioPlayer!.setAudioSource(audioSource);

    await audioPlayer!.play();
    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        // ✅ reset isPlaying when song finishes
        this.state = this.state?.copyWith(isPlaying: false);
      }
    });
    _homeLocalRepository.uploadLocalSong(song);
    // ✅ set isPlaying inside state

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
