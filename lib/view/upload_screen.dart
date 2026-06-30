// lib/screens/upload_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/album_model.dart';
import '../services/firebase_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedAlbumId;
  List<Album> _albums = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    final albums = await _firebaseService.getAllAlbums();
    setState(() => _albums = albums);
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      setState(() => _isLoading = true);

      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final photo = await _firebaseService.uploadPhoto(
        pickedFile.path,
        albumId: _selectedAlbumId,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      if (mounted) {
        if (photo != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo uploaded successfully!')),
          );
          _descriptionController.clear();
          setState(() => _selectedAlbumId = null);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload photo')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Photo to Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Album Selection
            const Text('Select Album (Optional)'),
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

            // Description
            const Text('Description (Optional)'),
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

            // Upload Buttons
            if (!_isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickAndUploadImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _pickAndUploadImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose from Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
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