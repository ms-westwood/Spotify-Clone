import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/core/team/app_pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:client/core/widgets/loader.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Color selectedColor = Pallete.cardColor;

  File? selectedImage;
  File? selectedAudio;

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });

      print(pickedImage.path);
    }
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider's state to check loading
    final state = ref.watch(homeViewModelProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewModelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      artist: artistController.text,
                      selectedColor: selectedColor,
                    );
              } else {
                showSnackBar(context, "Please fill all the fields");
                return;
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      /// IMAGE PICKER
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  dashPattern: [20, 8],
                                  strokeWidth: 2,
                                  color: Pallete.borderColor,
                                  radius: const Radius.circular(10),
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
                      ),

                      const SizedBox(height: 40),
                      selectedAudio != null
                          ? AudioWave(audioPath: selectedAudio!.path)
                          : CustomField(
                              hintText: 'Pick Song',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
                            ),

                      const SizedBox(height: 20),

                      /// ARTIST FIELD
                      CustomField(
                        hintText: 'Artist',
                        controller: artistController,
                      ),

                      const SizedBox(height: 20),

                      /// SONG NAME FIELD
                      CustomField(
                        hintText: 'Song Name',
                        controller: songNameController,
                      ),

                      const SizedBox(height: 20),

                      /// COLOR PICKER
                      ColorPicker(
                        pickersEnabled: const {ColorPickerType.wheel: true},
                        color: selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
