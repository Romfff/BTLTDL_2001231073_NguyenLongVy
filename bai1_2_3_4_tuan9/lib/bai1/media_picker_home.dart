import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class MediaPickerHome extends StatefulWidget {
  const MediaPickerHome({super.key});

  @override
  _MediaPickerHomeState createState() => _MediaPickerHomeState();
}

class _MediaPickerHomeState extends State<MediaPickerHome> {
  File? _mediaFile; // Lưu trữ file media (hình ảnh hoặc video)
  VideoPlayerController? _videoController; // Điều khiển phát video
  final ImagePicker _picker = ImagePicker(); // Khởi tạo ImagePicker

  @override
  void dispose() {
    // Giải phóng bộ nhớ của video controller khi widget bị hủy để tránh memory leak
    _videoController?.dispose();
    super.dispose();
  }

  // Kiểm tra và yêu cầu quyền truy cập một cách chuyên nghiệp hơn
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Nếu người dùng đã từ chối vĩnh viễn, hướng dẫn họ vào cài đặt
      if (mounted) {
        _showSettingsDialog();
      }
      return false;
    } else {
      // Yêu cầu quyền
      final result = await permission.request();
      return result.isGranted;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cần cấp quyền'),
        content: const Text('Ứng dụng cần quyền này để hoạt động. Vui lòng cấp quyền trong phần cài đặt.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Cài đặt'),
          ),
        ],
      ),
    );
  }

  // Hàm xử lý khởi tạo video để tái sử dụng
  Future<void> _initializeVideo(File file) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(file);
    try {
      await _videoController!.initialize();
      setState(() {});
      _videoController!.play();
      _videoController!.setLooping(true);
    } catch (e) {
      debugPrint("Lỗi khởi tạo video: $e");
    }
  }

  // Chọn ảnh hoặc video từ Thư viện (Gallery)
  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    // Với Android 13+, quyền photos/videos khác với các bản cũ
    bool hasPermission = false;
    if (Platform.isAndroid) {
      hasPermission = await _requestPermission(Permission.storage);
    } else {
      hasPermission = await _requestPermission(Permission.photos);
    }

    if (!hasPermission) return;

    final XFile? pickedFile = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(
            source: source,
            maxWidth: 1920,
            maxHeight: 1080,
            imageQuality: 100,
          );

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
      });

      if (isVideo) {
        await _initializeVideo(_mediaFile!);
      } else {
        _videoController?.dispose();
        _videoController = null;
      }
    } else {
      _showSnackBar('Bạn chưa chọn tệp nào.');
    }
  }

  // Chụp ảnh hoặc quay video từ Camera
  Future<void> _captureMedia(bool isVideo) async {
    // Yêu cầu quyền Camera và Microphone (nếu là video)
    final camStatus = await _requestPermission(Permission.camera);
    if (!camStatus) return;

    if (isVideo) {
      final micStatus = await _requestPermission(Permission.microphone);
      if (!micStatus) return;
    }

    final XFile? capturedFile = isVideo
        ? await _picker.pickVideo(source: ImageSource.camera)
        : await _picker.pickImage(source: ImageSource.camera);

    if (capturedFile != null) {
      setState(() {
        _mediaFile = File(capturedFile.path);
      });

      if (isVideo) {
        await _initializeVideo(_mediaFile!);
      } else {
        _videoController?.dispose();
        _videoController = null;
      }
    } else {
      _showSnackBar('Bạn chưa chụp/quay gì.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Picker App'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Hiển thị Preview
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _mediaFile == null
                    ? const Center(child: Text('Chưa có dữ liệu media.'))
                    : (_videoController != null && _videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : Image.file(_mediaFile!, fit: BoxFit.contain)),
              ),
            ),
            const SizedBox(height: 30),
            // Các nút chức năng
            _buildActionButton(
              icon: Icons.photo_library,
              label: 'Chọn ảnh từ Gallery',
              onPressed: () => _pickMedia(ImageSource.gallery, false),
            ),
            _buildActionButton(
              icon: Icons.camera_alt,
              label: 'Chụp ảnh từ Camera',
              onPressed: () => _captureMedia(false),
            ),
            _buildActionButton(
              icon: Icons.video_library,
              label: 'Chọn video từ Gallery',
              onPressed: () => _pickMedia(ImageSource.gallery, true),
            ),
            _buildActionButton(
              icon: Icons.videocam,
              label: 'Quay video từ Camera',
              onPressed: () => _captureMedia(true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}