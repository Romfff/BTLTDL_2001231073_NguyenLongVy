import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  // Fake database bằng List
  final List<Map<String, dynamic>> _students = [];
  int _idCounter = 1;

  Future<int> insertStudent(String name, String email) async {
    _students.add({
      'id': _idCounter++,
      'name': name,
      'email': email,
    });
    return 1;
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    return _students;
  }
}