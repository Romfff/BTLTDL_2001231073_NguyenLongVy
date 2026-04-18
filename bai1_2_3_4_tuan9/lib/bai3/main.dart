import 'dart:io';
import 'package:flutter/foundation.dart'; // Kiểm tra kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoRecorderApp());
}

class VideoRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Recorder & Playback',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: VideoRecorderHome(),
    );
  }
}

class VideoRecorderHome extends StatefulWidget {
  @override
  _VideoRecorderHomeState createState() => _VideoRecorderHomeState();
}

class _VideoRecorderHomeState extends State<VideoRecorderHome> {
  XFile? _videoFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  // Chọn video từ gallery
  Future<void> _pickVideoFromGallery() async {
    try {
      final XFile? selected = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (selected != null) {
        _loadVideo(selected);
      }
    } catch (e) {
      debugPrint("Lỗi chọn video: $e");
    }
  }

  // Quay video từ camera
  Future<void> _recordVideoFromCamera() async {
    try {
      final XFile? recorded = await _picker.pickVideo(
        source: ImageSource.camera,
      );
      if (recorded != null) {
        _loadVideo(recorded);
      }
    } catch (e) {
      debugPrint("Lỗi quay video: $e");
    }
  }

  // Tải và khởi tạo video
  Future<void> _loadVideo(XFile file) async {
    // Giải phóng controller cũ nếu có
    await _videoController?.dispose();

    setState(() {
      _videoFile = file;
      
      // Trên Web dùng network (blob url), trên Mobile dùng file
      if (kIsWeb) {
        _videoController = VideoPlayerController.network(file.path);
      } else {
        _videoController = VideoPlayerController.file(File(file.path));
      }
    });

    try {
      await _videoController!.initialize();
      setState(() {}); // Cập nhật để hiển thị khung hình đầu tiên
      _videoController!.play();
    } catch (e) {
      debugPrint("Lỗi khởi tạo video: $e");
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Recorder & Playback'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Vùng hiển thị Video
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 350,
                width: double.infinity,
                child: _videoController != null && _videoController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                            // Nút Play/Pause đè lên video
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _videoController!.value.isPlaying
                                      ? _videoController!.pause()
                                      : _videoController!.play();
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black26,
                                child: Icon(
                                  _videoController!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'Chưa có video nào được chọn.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
              ),
              
              SizedBox(height: 30),
              
              // Nút bấm điều khiển
              _buildButton(
                onPressed: _pickVideoFromGallery,
                text: 'Chọn video từ Gallery',
                icon: Icons.video_library,
              ),
              SizedBox(height: 12),
              _buildButton(
                onPressed: _recordVideoFromCamera,
                text: 'Quay video từ Camera',
                icon: Icons.videocam,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required VoidCallback onPressed, required String text, required IconData icon}) {
    return SizedBox(
      width: 280,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF3F0FF),
          foregroundColor: Colors.purple,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Color(0xFFDDD6FE)),
          ),
        ),
      ),
    );
  }
}