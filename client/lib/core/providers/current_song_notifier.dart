import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer ??= AudioPlayer();

    final audioSource = AudioSource.uri(Uri.parse(song.song_url));
    await audioPlayer!.setAudioSource(audioSource);

    await audioPlayer!.play();

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
}
