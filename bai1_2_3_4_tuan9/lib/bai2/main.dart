import 'dart:io';
import 'package:flutter/foundation.dart'; // Kiểm tra kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(PhotoCaptureApp());
}

class PhotoCaptureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Capture & Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: PhotoCaptureHome(),
    );
  }
}

class PhotoCaptureHome extends StatefulWidget {
  @override
  _PhotoCaptureHomeState createState() => _PhotoCaptureHomeState();
}

class _PhotoCaptureHomeState extends State<PhotoCaptureHome> {
  XFile? _pickedFile; // Sử dụng XFile thay vì File để tương thích cả Web và Mobile
  final ImagePicker _picker = ImagePicker();

  // Chọn ảnh từ gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (selected != null) {
        setState(() {
          _pickedFile = selected;
        });
      }
    } catch (e) {
      debugPrint("Lỗi chọn ảnh: $e");
    }
  }

  // Chụp ảnh từ camera
  Future<void> _captureImageFromCamera() async {
    try {
      final XFile? captured = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (captured != null) {
        setState(() {
          _pickedFile = captured;
        });
      }
    } catch (e) {
      debugPrint("Lỗi chụp ảnh: $e");
    }
  }

  // Xem trước ảnh toàn màn hình
  void _showFullScreenPreview(BuildContext context) {
    if (_pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(imageFile: _pickedFile!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Capture & Preview'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị ảnh hoặc placeholder
            Expanded(
              child: Center(
                child: _pickedFile == null
                    ? Text(
                        'Chưa có ảnh nào được chọn.',
                        style: TextStyle(color: Colors.grey[600]),
                      )
                    : GestureDetector(
                        onTap: () => _showFullScreenPreview(context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: kIsWeb 
                            ? Image.network(_pickedFile!.path, height: 300) // Web dùng Image.network
                            : Image.file(File(_pickedFile!.path), height: 300), // Mobile dùng Image.file
                        ),
                      ),
              ),
            ),
            SizedBox(height: 30),
            // Nút bấm
            _buildButton(
              onPressed: _pickImageFromGallery,
              text: 'Chọn ảnh từ Gallery',
            ),
            SizedBox(height: 12),
            _buildButton(
              onPressed: _captureImageFromCamera,
              text: 'Chụp ảnh từ Camera',
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required VoidCallback onPressed, required String text}) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF3F0FF),
          foregroundColor: Colors.deepPurple,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Color(0xFFDDD6FE)),
          ),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// Widget xem trước toàn màn hình
class FullScreenImage extends StatelessWidget {
  final XFile imageFile;
  FullScreenImage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Xem trước', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: kIsWeb 
          ? Image.network(imageFile.path) 
          : Image.file(File(imageFile.path)),
      ),
    );
  }
}