import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final String id;
  final String userId;
  final String storageUrl;
  final DateTime uploadedAt;
  final String? albumId;
  final String? description;

  Photo({
    required this.id,
    required this.userId,
    required this.storageUrl,
    required this.uploadedAt,
    this.albumId,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'storageUrl': storageUrl,
      'uploadedAt': uploadedAt,
      'albumId': albumId,
      'description': description,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      storageUrl: map['storageUrl'] ?? '',
      uploadedAt: (map['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      albumId: map['albumId'],
      description: map['description'],
    );
  }

  Photo copyWith({
    String? id,
    String? userId,
    String? storageUrl,
    DateTime? uploadedAt,
    String? albumId,
    String? description,
  }) {
    return Photo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storageUrl: storageUrl ?? this.storageUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      albumId: albumId ?? this.albumId,
      description: description ?? this.description,
    );
  }
}