import 'package:flutter/material.dart';
import 'media_picker_home.dart';

void main() {
  // Đảm bảo các dịch vụ của Flutter được khởi tạo trước khi chạy app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediaPickerApp());
}

class MediaPickerApp extends StatelessWidget {
  const MediaPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Picker App',
      debugShowCheckedModeBanner: false, // Tắt biểu tượng debug ở góc màn hình
      theme: ThemeData(
        // Sử dụng Material 3 để có giao diện hiện đại hơn
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        // Cấu hình font chữ và padding mặc định cho các button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
      // Gọi màn hình chính từ file media_picker_home.dart
      home: const MediaPickerHome(),
    );
  }
}