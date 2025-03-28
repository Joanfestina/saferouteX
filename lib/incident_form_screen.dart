import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io';

class IncidentFormScreen extends StatefulWidget {
  @override
  _IncidentFormScreenState createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImageFile;
  String? _selectedImageUrl; // For web
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    if (kIsWeb) {
      // For web, store the file path as a URL
      setState(() {
        _selectedImageUrl = pickedFile.path;
      });
    } else {
      // For mobile, store the file as a File object
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }
}
  Future<String?> _uploadPhoto() async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('incident_photos/${DateTime.now().millisecondsSinceEpoch}.jpg');

      if (kIsWeb && _selectedImageUrl != null) {
        // For web, upload using the picked file path
        final uploadTask = await storageRef.putData(
          await XFile(_selectedImageUrl!).readAsBytes(),
        );
        return await uploadTask.ref.getDownloadURL();
      } else if (_selectedImageFile != null) {
        // For mobile, upload using the File object
        final uploadTask = await storageRef.putFile(_selectedImageFile!);
        return await uploadTask.ref.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
    return null;
  }

  Future<void> _submitReport() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Description are required')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    String? photoUrl;
    if (_selectedImageFile != null || _selectedImageUrl != null) {
      photoUrl = await _uploadPhoto();
    }

    final reportData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'photoUrl': photoUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('incidents').add(reportData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report submitted successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit report')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Report Incident')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          if (kIsWeb && _selectedImageUrl != null)
            Image.network(_selectedImageUrl!, height: 150)
          else if (_selectedImageFile != null)
            Image.file(_selectedImageFile!, height: 150)
          else
            const Text('No photo selected'),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo),
            label: const Text('Add Photo'),
          ),
          const SizedBox(height: 16),
          _isSubmitting
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submitReport,
                  child: const Text('Submit Report'),
                ),
        ],
      ),
    ),
  );
}
}