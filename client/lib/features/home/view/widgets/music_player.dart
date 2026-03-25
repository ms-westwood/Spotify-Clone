import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/team/app_pallete.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);

    if (currentSong == null) {
      return const Scaffold(body: Center(child: Text("No song playing")));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Pallete.gradient1, const Color(0xFF121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/pull-down-arrow.png",
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            /// 🔝 IMAGE
            /// 🔝 IMAGE
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20), // ← adds space below AppBar
                    Expanded(
                      child: Hero(
                        tag: 'music-image',
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(currentSong.thumbnail_url),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10), // smaller spacing than before
            /// 🎵 SONG INFO + CONTROLS
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Song Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.song_name,
                              style: const TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6), // small gap
                            Text(
                              currentSong.artist,
                              style: const TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(homeViewModelProvider.notifier)
                                .favSong(songId: currentSong.id);
                          },
                          icon: const Icon(
                            CupertinoIcons.heart,
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 10), // smaller spacing than before
                    /// Slider
                    StreamBuilder(
                      stream: songNotifier.audioPlayer?.positionStream,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        final position = asyncSnapshot.data;
                        final duration = songNotifier.audioPlayer!.duration;
                        double sliderValue = 0.0;
                        if (position != null && duration != null) {
                          sliderValue =
                              position.inMilliseconds / duration.inMilliseconds;
                        }
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Pallete.whiteColor,
                                inactiveTrackColor: Pallete.whiteColor
                                    .withOpacity(0.1),
                                thumbColor: Pallete.whiteColor,
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: sliderValue,
                                min: 0,
                                max: 1,
                                onChanged: (value) {
                                  final duration =
                                      songNotifier.audioPlayer!.duration;

                                  if (duration != null) {
                                    final newPosition = duration * value;
                                    songNotifier.audioPlayer!.seek(newPosition);
                                  }
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${position?.inMinutes}:${(position?.inSeconds ?? 0) < 10 ? '0' : ''}${position?.inSeconds.remainder(60)}',
                                  style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0' : ''}${duration?.inSeconds.remainder(60)}',
                                  style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    /// Time Row
                    const SizedBox(height: 20), // space before controls
                    /// Controls Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/shuffle.png",
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/previus-song.png",
                            color: Pallete.whiteColor,
                          ),
                        ),
                        IconButton(
                          onPressed: songNotifier.togglePlayPause,
                          icon: Icon(
                            currentSong.isPlaying
                                ? CupertinoIcons.pause_circle_fill
                                : CupertinoIcons.play_circle_fill,
                            color: Pallete.whiteColor,
                          ),
                          iconSize: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/next-song.png",
                            color: Pallete.whiteColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/repeat.png",
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    /// Bottom Row (Connect / Playlist)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/connect-device.png",
                            color: Pallete.whiteColor,
                          ),
                        ),
                        const Expanded(child: SizedBox(width: 10)),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/playlist.png",
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
