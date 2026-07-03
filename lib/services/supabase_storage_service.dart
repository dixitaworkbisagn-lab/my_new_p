import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image/image.dart' as img;

class SupabaseStorageService {
  final _supabase = Supabase.instance.client;

  String get userId => _supabase.auth.currentUser!.id;

  // Compress image before upload
  Future<File> compressImage(String imagePath) async {
    final imageFile = File(imagePath);
    final imageBytes = imageFile.readAsBytesSync();
    final image = img.decodeImage(imageBytes);

    if (image == null) return imageFile;

    // Resize and compress
    final resized = img.copyResize(image, width: 1200);
    final compressed = img.encodeJpg(resized, quality: 80);

    final compressedFile = File(imagePath)..writeAsBytesSync(compressed);
    return compressedFile;
  }

  // Upload photo
  Future<String?> uploadPhoto(String imagePath) async {
    try {
      // Compress first
      final compressedFile = await compressImage(imagePath);

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = '$userId/$fileName';

      // Upload
      await _supabase.storage.from('photos').upload(
        storagePath,
        compressedFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      // Get public URL
      final publicUrl = _supabase.storage.from('photos').getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Get all photo URLs for user
  Future<List<String>> getUserPhotos() async {
    try {
      final files = await _supabase.storage.from('photos').list(path: userId);

      return files
          .map((file) => _supabase.storage.from('photos')
          .getPublicUrl('$userId/${file.name}'))
          .toList();
    } catch (e) {
      print('Error fetching photos: $e');
      return [];
    }
  }
}