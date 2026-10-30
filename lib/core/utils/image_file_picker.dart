import 'dart:typed_data';
import 'image_file_picker_io.dart'
    if (dart.library.html) 'image_file_picker_web.dart' as impl;

/// Fungsi pemilih foto galeri kartu yang aman di Web dan Mobile
Future<Uint8List?> pickCustomCardImage() => impl.pickImageFile();
