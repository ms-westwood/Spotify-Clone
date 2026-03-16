import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String rgbToHex(Color color) {
  return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}

Future<File?> pickAudio() async {
  try {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }

    return null;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerRes != null) {
      return File(filePickerRes!.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}
