// // lib/services/firebase_service.dart
// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';
// import '../models/album_model.dart';
// import '../models/photo_model.dart';
//
// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Get current user ID
//   String? get userId => _auth.currentUser?.uid;
//
//
//   Future<Photo?> uploadPhoto(
//       String imagePath, {
//         String? albumId,
//         String? description,
//       }) async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       final photoId = const Uuid().v4();
//       final fileName = '$photoId.jpg';
//       final ref = _storage.ref().child('photos/$userId/$fileName');
//
//       // Upload file
//       final file = File(imagePath);
//       await ref.putFile(file);
//
//       // Get download URL
//       final downloadUrl = await ref.getDownloadURL();
//
//       // Create photo object
//       final photo = Photo(
//         id: photoId,
//         userId: userId!,
//         storageUrl: downloadUrl,
//         uploadedAt: DateTime.now(),
//         albumId: albumId,
//         description: description, storagePath: '',
//       );
//
//       // await _firestore
//       //     .collection('photos')
//       //     .doc(userId)
//       //     .collection('photos')
//       //     .doc(photoId)
//       //     .set(photo.toMap());
//
//       return photo;
//     } catch (e) {
//       print('Error uploading photo: $e');
//       return null;
//     }
//   }
//
//   /// Get all photos for current user
//   Future<List<Photo>> getAllPhotos() async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       final snapshot = await _firestore
//           .collection('photos')
//           .doc(userId)
//           .collection('photos')
//           .orderBy('uploadedAt', descending: true)
//           .get();
//
//       return snapshot.docs.map((doc) => Photo.fromMap(doc.data())).toList();
//     } catch (e) {
//       print('Error fetching photos: $e');
//       return [];
//     }
//   }
//
//   /// Get photos from specific album
//   Future<List<Photo>> getAlbumPhotos(String albumId) async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       final snapshot = await _firestore
//           .collection('photos')
//           .doc(userId)
//           .collection('photos')
//           .where('albumId', isEqualTo: albumId)
//           .orderBy('uploadedAt', descending: true)
//           .get();
//
//       return snapshot.docs.map((doc) => Photo.fromMap(doc.data())).toList();
//     } catch (e) {
//       print('Error fetching album photos: $e');
//       return [];
//     }
//   }
//
//   /// Add photo to album
//   Future<bool> addPhotoToAlbum(String photoId, String albumId) async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       await _firestore
//           .collection('photos')
//           .doc(userId)
//           .collection('photos')
//           .doc(photoId)
//           .update({'albumId': albumId});
//
//       return true;
//     } catch (e) {
//       print('Error adding photo to album: $e');
//       return false;
//     }
//   }
//
//   // ALBUM OPERATIONS
//
//   /// Create a new album
//   Future<Album?> createAlbum(String name, {String? description}) async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       final albumId = const Uuid().v4();
//       final album = Album(
//         id: albumId,
//         userId: userId!,
//         name: name,
//         description: description,
//         createdAt: DateTime.now(),
//         photoCount: 0,
//       );
//
//       await _firestore
//           .collection('albums')
//           .doc(userId)
//           .collection('albums')
//           .doc(albumId)
//           .set(album.toMap());
//
//       return album;
//     } catch (e) {
//       print('Error creating album: $e');
//       return null;
//     }
//   }
//
//   /// Get all albums for current user
//   Future<List<Album>> getAllAlbums() async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       final snapshot = await _firestore
//           .collection('albums')
//           .doc(userId)
//           .collection('albums')
//           .orderBy('createdAt', descending: true)
//           .get();
//
//       return snapshot.docs.map((doc) => Album.fromMap(doc.data())).toList();
//     } catch (e) {
//       print('Error fetching albums: $e');
//       return [];
//     }
//   }
//
//   /// Update album details
//   Future<bool> updateAlbum(String albumId, String name, {String? description}) async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       await _firestore
//           .collection('albums')
//           .doc(userId)
//           .collection('albums')
//           .doc(albumId)
//           .update({
//         'name': name,
//         'description': description,
//       });
//
//       return true;
//     } catch (e) {
//       print('Error updating album: $e');
//       return false;
//     }
//   }
//
//   /// Get album photo count
//   Future<int?> getAlbumPhotoCount(String albumId) async {
//     try {
//       if (userId == null) throw Exception('User not authenticated');
//
//       final snapshot = await _firestore
//           .collection('photos')
//           .doc(userId)
//           .collection('photos')
//           .where('albumId', isEqualTo: albumId)
//           .count()
//           .get();
//
//       return snapshot.count;
//     } catch (e) {
//       print('Error getting album photo count: $e');
//       return 0;
//     }
//   }
// }