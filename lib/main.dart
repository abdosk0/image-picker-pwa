import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:image_picker_web/image_picker_web.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Editor PWA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageEditorPage(),
    );
  }
}

class ImageEditorPage extends StatefulWidget {
  @override
  _ImageEditorPageState createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  Uint8List? _editedImageBytes;

  Future<void> _pickImage() async {
    final Uint8List? imageBytes = await ImagePickerWeb.getImageAsBytes();
    if (imageBytes != null) {
      setState(() {
        _editedImageBytes = imageBytes;
      });
    }
  }

  Future<void> _editImage() async {
  if (_editedImageBytes != null) {
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.memory(
          _editedImageBytes!, // Pass the image bytes
          onImageEditingComplete: (editedImage) async { // Add 'async' here
            setState(() {
              _editedImageBytes = editedImage;
            });
            Navigator.pop(context);
            return; // Add this return statement
          },
        ),
      ),
    );
    if (editedImage != null) {
      setState(() {
        _editedImageBytes = editedImage;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Editor PWA'),
      ),
      body: Center(
        child: _editedImageBytes != null
            ? Image.memory(
                _editedImageBytes!,
                height: 200,
              )
            : Text('No image selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Select or Capture Image',
        child: Icon(Icons.add_a_photo),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _editImage,
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                // Add your save functionality here
                // For example, you can save the edited image to local storage or cloud storage
              },
              icon: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
