import 'package:client/core/widgets/loader.dart';
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
            return Container();
          },
          error: (err, stack) {
            return Center(child: Text(err.toString()));
          },
          loading: () => const Loader(),
        );
  }
}
