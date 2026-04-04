import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class SanPham {
  String ma;
  String ten;
  double gia;
  double giamGia;

  SanPham({
    required this.ma,
    required this.ten,
    required this.gia,
    required this.giamGia,
  });

  double tinhThue() => gia * 0.1;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SanPhamScreen(),
    );
  }
}

class SanPhamScreen extends StatefulWidget {
  const SanPhamScreen({super.key});

  @override
  State<SanPhamScreen> createState() => _SanPhamScreenState();
}

class _SanPhamScreenState extends State<SanPhamScreen> {
  List<SanPham> list = [];

  final maCtrl = TextEditingController();
  final tenCtrl = TextEditingController();
  final giaCtrl = TextEditingController();
  final giamCtrl = TextEditingController();

  void themSanPham() {
    if (maCtrl.text.isEmpty ||
        tenCtrl.text.isEmpty ||
        giaCtrl.text.isEmpty ||
        giamCtrl.text.isEmpty) return;

    setState(() {
      list.add(SanPham(
        ma: maCtrl.text,
        ten: tenCtrl.text,
        gia: double.parse(giaCtrl.text),
        giamGia: double.parse(giamCtrl.text),
      ));
    });

    maCtrl.clear();
    tenCtrl.clear();
    giaCtrl.clear();
    giamCtrl.clear();

    Navigator.pop(context);
  }

  void showForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thêm sản phẩm"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: maCtrl, decoration: const InputDecoration(hintText: "Mã")),
              TextField(controller: tenCtrl, decoration: const InputDecoration(hintText: "Tên")),
              TextField(controller: giaCtrl, decoration: const InputDecoration(hintText: "Giá")),
              TextField(controller: giamCtrl, decoration: const InputDecoration(hintText: "Giảm giá")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(onPressed: themSanPham, child: const Text("Lưu")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    maCtrl.dispose();
    tenCtrl.dispose();
    giaCtrl.dispose();
    giamCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý sản phẩm")),
      body: list.isEmpty
          ? const Center(child: Text("Chưa có sản phẩm"))
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final sp = list[index];
                return Card(
                  child: ListTile(
                    title: Text(sp.ten),
                    subtitle: Text(
                      "Mã: ${sp.ma}\n"
                      "Giá: ${sp.gia}\n"
                      "Giảm: ${sp.giamGia}\n"
                      "Thuế: ${sp.tinhThue()}",
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}