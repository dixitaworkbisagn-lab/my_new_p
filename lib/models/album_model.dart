import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final int photoCount;

  Album({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.createdAt,
    this.photoCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'photoCount': photoCount,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      photoCount: map['photoCount'] ?? 0,
    );
  }
}