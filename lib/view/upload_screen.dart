import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/album_model.dart';
import '../services/supabase_storage_service.dart';
import '../services/supabase_db_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _storageService = SupabaseStorageService();
  final _dbService = SupabaseDbService();
  final _picker = ImagePicker();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  String? _selectedAlbumId;
  List<Album> _albums = [];

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    final albums = await _dbService.getAlbums();
    setState(() => _albums = albums);
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    try {
      setState(() => _isLoading = true);

      final file = await _picker.pickImage(source: source);
      if (file == null) return;

      // Upload photo
      final url = await _storageService.uploadPhoto(file.path);
      if (url == null) throw Exception('Upload failed');

      // Save to database
      final success = await _dbService.addPhoto(
        storageUrl: url,
        storagePath: '$_selectedAlbumId/${DateTime.now().millisecondsSinceEpoch}.jpg',
        albumId: _selectedAlbumId,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo uploaded!')),
          );
          _descriptionController.clear();
          setState(() => _selectedAlbumId = null);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Album (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String?>(
              value: _selectedAlbumId,
              isExpanded: true,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('No Album'),
                ),
                ..._albums.map((album) {
                  return DropdownMenuItem(
                    value: album.id,
                    child: Text(album.name),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() => _selectedAlbumId = value);
              },
            ),
            const SizedBox(height: 24),
            const Text('Description (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (!_isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickAndUpload(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _pickAndUpload(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose from Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}