import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/album_model.dart';
import '../models/photo_model.dart';

class SupabaseDbService {
  final _supabase = Supabase.instance.client;

  String get userId => _supabase.auth.currentUser!.id;

  // ALBUMS

  Future<Album?> createAlbum(String name, {String? description}) async {
    try {
      final data = await _supabase
          .from('albums')
          .insert({
        'user_id': userId,
        'name': name,
        'description': description,
      })
          .select()
          .single();

      return Album.fromMap(data);
    } catch (e) {
      print('Error creating album: $e');
      return null;
    }
  }

  Future<List<Album>> getAlbums() async {
    try {
      final data = await _supabase
          .from('albums')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (data as List).map((item) => Album.fromMap(item)).toList();
    } catch (e) {
      print('Error fetching albums: $e');
      return [];
    }
  }

  Future<bool> updateAlbum(String albumId, String name, {String? description}) async {
    try {
      await _supabase
          .from('albums')
          .update({
        'name': name,
        'description': description,
      })
          .eq('id', albumId)
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('Error updating album: $e');
      return false;
    }
  }

  // PHOTOS

  Future<bool> addPhoto({
    required String storageUrl,
    required String storagePath,
    String? albumId,
    String? description,
  }) async {
    try {
      await _supabase.from('photos').insert({
        'user_id': userId,
        'album_id': albumId,
        'storage_url': storageUrl,
        'storage_path': storagePath,
        'description': description,
      });

      return true;
    } catch (e) {
      print('Error adding photo: $e');
      return false;
    }
  }

  Future<List<Photo>> getAllPhotos() async {
    try {
      final data = await _supabase
          .from('photos')
          .select()
          .eq('user_id', userId)
          .order('uploaded_at', ascending: false);

      return (data as List).map((item) => Photo.fromMap(item)).toList();
    } catch (e) {
      print('Error fetching photos: $e');
      return [];
    }
  }

  Future<List<Photo>> getAlbumPhotos(String albumId) async {
    try {
      final data = await _supabase
          .from('photos')
          .select()
          .eq('user_id', userId)
          .eq('album_id', albumId)
          .order('uploaded_at', ascending: false);

      return (data as List).map((item) => Photo.fromMap(item)).toList();
    } catch (e) {
      print('Error fetching album photos: $e');
      return [];
    }
  }
}