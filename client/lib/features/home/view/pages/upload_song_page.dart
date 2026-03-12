import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:client/core/team/app_pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Song"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            DottedBorder(
              options: RectDottedBorderOptions(
                dashPattern: [10, 4],
                strokeWidth: 2,
                color: Pallete.borderColor,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.file_open, size: 40),
                    SizedBox(height: 15),
                    Text(
                      "Select the thumbnail for your song",
                      style: TextStyle(
                        fontSize: 15,
                        color: Pallete.borderColor,
                      ),
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
