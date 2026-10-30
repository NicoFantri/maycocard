import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

/// Implementasi pemilihan foto untuk platform native / IO menggunakan image_picker
Future<Uint8List?> pickImageFile() async {
  try {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1000,
      imageQuality: 90,
    );
    if (file != null) {
      return await file.readAsBytes();
    }
  } catch (_) {}
  return null;
}
