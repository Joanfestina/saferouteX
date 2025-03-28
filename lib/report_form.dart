// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ReportForm extends StatefulWidget {
//   @override
//   _ReportFormState createState() => _ReportFormState();
// }

// class _ReportFormState extends State<ReportForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   File? _selectedImage;
//   String? _photoUrl;
//   bool _isSubmitting = false;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });

//       // Upload the photo and set the URL
//       _photoUrl = await _uploadPhoto(_selectedImage!);
//     } else {
//       _showError("No image selected.");
//     }
//   }

//   Future<String?> _uploadPhoto(File image) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('incident_photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
//       final uploadTask = storageRef.putFile(image);
//       final snapshot = await uploadTask.whenComplete(() => {});
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       print('Error uploading photo: $e');
//       return null;
//     }
//   }

//   void _submitReport() async {
//   String title = _titleController.text.trim();
//   String description = _descriptionController.text.trim();

//   if (title.isEmpty || description.isEmpty) {
//     _showError("Please fill in all fields.");
//     return;
//   }

//   try {
//     await FirebaseFirestore.instance.collection('incidents').add({
//       'title': title,
//       'description': description,
//       'photoUrl': _photoUrl ?? '',
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Report submitted successfully!')),
//     );

//     Navigator.pop(context); // Return to the previous screen
//   } catch (e) {
//     _showError("Failed to submit report. Try again.");
//   }
// }

// void _showError(String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
//   );
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Report Incident')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Title is required' : null,
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 validator: (value) => value == null || value.isEmpty
//                     ? 'Description is required'
//                     : null,
//               ),
//               SizedBox(height: 16),
//               _selectedImage != null
//                   ? Image.file(_selectedImage!, height: 150)
//                   : Text('No photo selected'),
//               TextButton.icon(
//                 onPressed: _pickImage,
//                 icon: Icon(Icons.photo),
//                 label: Text('Add Photo'),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _isSubmitting ? null : _submitReport,
//                 child: _isSubmitting
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text('Submit Report'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadPhoto(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('incident_photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    String? photoUrl;
    if (_selectedImage != null) {
      photoUrl = await _uploadPhoto(_selectedImage!);
    }

    try {
      await FirebaseFirestore.instance.collection('incidents').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'photoUrl': photoUrl ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: 12),
                if (_selectedImage != null)
                  Image.file(_selectedImage!, height: 150),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('Add Photo'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}