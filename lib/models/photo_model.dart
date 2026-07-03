class Photo {
  final String id;
  final String userId;
  final String? albumId;
  final String storagePath;
  final String storageUrl;
  final String? description;
  final DateTime uploadedAt;

  Photo({
    required this.id,
    required this.userId,
    this.albumId,
    required this.storagePath,
    required this.storageUrl,
    this.description,
    required this.uploadedAt,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      albumId: map['album_id'],
      storagePath: map['storage_path'] ?? '',
      storageUrl: map['storage_url'] ?? '',
      description: map['description'],
      uploadedAt: DateTime.parse(map['uploaded_at'] ?? DateTime.now().toString()),
    );
  }
}