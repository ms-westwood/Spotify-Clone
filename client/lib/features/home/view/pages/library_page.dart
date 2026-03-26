import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/team/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getAllFavoriteSongsProvider)
        .when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                // ➕ Last item (Add button)
                if (index == data.length) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UploadSongPage(),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundColor: Pallete.backgroundColor,
                      child: const Icon(CupertinoIcons.plus),
                    ),
                    title: const Text(
                      "Upload New Song",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }

                // 🎵 Normal song item
                final song = data[index];

                return ListTile(
                  onTap: () {
                    ref.read(currentSongProvider.notifier).updateSong(song);
                  },
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundColor: Pallete.backgroundColor,
                    backgroundImage: NetworkImage(song.thumbnail_url),
                  ),
                  title: Text(
                    song.song_name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            );
          },
          error: (err, stack) {
            return Center(child: Text(err.toString()));
          },
          loading: () => const Loader(),
        );
  }
}
