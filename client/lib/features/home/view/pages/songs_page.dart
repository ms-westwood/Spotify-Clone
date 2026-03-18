import 'package:client/core/team/app_pallete.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:client/core/widgets/loader.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Latest Today",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),

          ref
              .watch(getAllSongsProvider)
              .when(
                data: (songs) {
                  return SizedBox(
                    height: 210, // slight increase to avoid overflow
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];

                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 180,
                                height: 160,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(song.thumbnail_url),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 5),

                              SizedBox(
                                width: 180,
                                child: Text(
                                  song.song_name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),

                              SizedBox(
                                width: 180,
                                child: Text(
                                  song.artist,
                                  style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) {
                  return Center(child: Text(error.toString()));
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
