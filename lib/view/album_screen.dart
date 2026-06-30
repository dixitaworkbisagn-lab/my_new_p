// lib/screens/albums_screen.dart
import 'package:flutter/material.dart';
import '../models/album_model.dart';
import '../services/firebase_service.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<Album>> _albumsFuture;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  void _loadAlbums() {
    setState(() {
      _albumsFuture = _firebaseService.getAllAlbums();
    });
  }

  void _showCreateAlbumDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Album'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Album Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description (optional)'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final album = await _firebaseService.createAlbum(
                nameController.text,
                description: descriptionController.text.isEmpty
                    ? null
                    : descriptionController.text,
              );

              if (mounted) {
                Navigator.pop(context);
                if (album != null) {
                  _loadAlbums();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Album created!')),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAlbumDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Album>>(
        future: _albumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final albums = snapshot.data ?? [];

          if (albums.isEmpty) {
            return const Center(
              child: Text('No albums yet. Create one!'),
            );
          }

          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(album.name),
                  subtitle: Text('${album.photoCount} photos'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => AlbumDetailScreen(album: album),
                    //   ),
                    // ).then((_) => _loadAlbums());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}