import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentScreen(),
    );
  }
}

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<Map<String, dynamic>> _students = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final data = await DatabaseHelper.instance.getStudents();
    setState(() {
      _students = data;
    });
  }

  void _addStudent() async {
    String name = _nameController.text;
    String email = _emailController.text;

    if (name.isEmpty || email.isEmpty) return;

    await DatabaseHelper.instance.insertStudent(name, email);

    _nameController.clear();
    _emailController.clear();

    Navigator.pop(context);
    _loadStudents();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thêm sinh viên"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Tên"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: _addStudent,
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách sinh viên")),
      body: _students.isEmpty
          ? const Center(child: Text("Chưa có dữ liệu"))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_students[index]['name']),
                  subtitle: Text(_students[index]['email']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}