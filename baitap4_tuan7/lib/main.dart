import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Model Chi Tieu
class ChiTieu {
  String noiDung;
  double soTien;
  String ghiChu;

  ChiTieu({
    required this.noiDung,
    required this.soTien,
    required this.ghiChu,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChiTieuScreen(),
    );
  }
}

class ChiTieuScreen extends StatefulWidget {
  const ChiTieuScreen({super.key});

  @override
  State<ChiTieuScreen> createState() => _ChiTieuScreenState();
}

class _ChiTieuScreenState extends State<ChiTieuScreen> {
  List<ChiTieu> list = [];

  final noiDungCtrl = TextEditingController();
  final soTienCtrl = TextEditingController();
  final ghiChuCtrl = TextEditingController();

  // Thêm chi tiêu
  void themChiTieu() {
    if (noiDungCtrl.text.isEmpty || soTienCtrl.text.isEmpty) return;

    setState(() {
      list.add(ChiTieu(
        noiDung: noiDungCtrl.text,
        soTien: double.parse(soTienCtrl.text),
        ghiChu: ghiChuCtrl.text,
      ));
    });

    noiDungCtrl.clear();
    soTienCtrl.clear();
    ghiChuCtrl.clear();

    Navigator.pop(context);
  }

  // Dialog nhập
  void showForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thêm chi tiêu"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: noiDungCtrl,
                decoration: const InputDecoration(hintText: "Nội dung"),
              ),
              TextField(
                controller: soTienCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Số tiền"),
              ),
              TextField(
                controller: ghiChuCtrl,
                decoration: const InputDecoration(hintText: "Ghi chú"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: themChiTieu,
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  // Tính tổng tiền
  double tongTien() {
    return list.fold(0, (sum, item) => sum + item.soTien);
  }

  @override
  void dispose() {
    noiDungCtrl.dispose();
    soTienCtrl.dispose();
    ghiChuCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý chi tiêu"),
      ),
      body: Column(
        children: [
          // Tổng tiền
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Tổng: ${tongTien()} VND",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Danh sách
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text("Chưa có dữ liệu"))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final ct = list[index];
                      return Card(
                        child: ListTile(
                          title: Text(ct.noiDung),
                          subtitle: Text(
                            "Tiền: ${ct.soTien}\nGhi chú: ${ct.ghiChu}",
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}