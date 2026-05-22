import 'package:flutter/material.dart';
import 'map_route_screen.dart'; // Import màn hình bản đồ mới tạo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUIT Navigator',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MapRouteScreen(), // Đặt MapRouteScreen làm trang chính
    );
  }
}