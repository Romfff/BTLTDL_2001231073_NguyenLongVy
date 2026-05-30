import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userId});

  static const String routeName = '/home';

  final int userId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _sampleData = const [
    {
      'SubjectName': 'Co so lap trinh',
      'SubjectCode': 'CS101',
      'Semester': 'Hoc ky 1',
      'AcademicYear': '2023-2024',
      'ProcessScore': 8.5,
      'ExamScore': 7.0,
      'FinalGrade': 'B',
    },
    {
      'SubjectName': 'Co so du lieu',
      'SubjectCode': 'CS102',
      'Semester': 'Hoc ky 1',
      'AcademicYear': '2023-2024',
      'ProcessScore': 9.0,
      'ExamScore': 8.5,
      'FinalGrade': 'A',
    },
    {
      'SubjectName': 'Lap trinh huong doi tuong',
      'SubjectCode': 'CS103',
      'Semester': 'Hoc ky 2',
      'AcademicYear': '2023-2024',
      'ProcessScore': 7.5,
      'ExamScore': 8.0,
      'FinalGrade': 'B',
    },
  ];

  List<Map<String, dynamic>> _results = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getAllResults();
  }

  Future<void> _getAllResults() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/results/${widget.userId}'),
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _results = data
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Khong the tai du lieu. Vui long thu lai sau.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Khong ket noi duoc API, dang hien thi du lieu mau.';
        _results = _sampleData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _results.isEmpty ? _sampleData : _results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('THEO DOI KET QUA HOC TAP SINH VIEN'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Thong tin ca nhan'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Cai dat'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Thoat'),
              onTap: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_errorMessage.isNotEmpty)
                  MaterialBanner(
                    content: Text(_errorMessage),
                    leading: const Icon(Icons.info_outline),
                    actions: [
                      TextButton(
                        onPressed: () => setState(() => _errorMessage = ''),
                        child: const Text('Dong'),
                      ),
                    ],
                  ),
                Expanded(child: _buildResultsTable(data)),
              ],
            ),
    );
  }

  Widget _buildResultsTable(List<Map<String, dynamic>> results) {
    final groupedResults = <String, List<Map<String, dynamic>>>{};
    for (final result in results) {
      final academicYear = _value(result, 'AcademicYear', 'academicYear');
      final semester = _value(result, 'Semester', 'semester');
      final key = '$academicYear - $semester';
      groupedResults.putIfAbsent(key, () => []).add(result);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: groupedResults.entries.map((entry) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('Ma mon hoc')),
                      DataColumn(label: Text('Ten mon hoc')),
                      DataColumn(label: Text('Diem qua trinh')),
                      DataColumn(label: Text('Diem thi')),
                      DataColumn(label: Text('Xep loai')),
                    ],
                    rows: entry.value.map((result) {
                      final grade = _value(result, 'FinalGrade', 'finalGrade');
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(_value(result, 'SubjectCode', 'subjectCode')),
                          ),
                          DataCell(
                            Text(_value(result, 'SubjectName', 'subjectName')),
                          ),
                          DataCell(
                            Text(
                              _value(result, 'ProcessScore', 'processScore'),
                            ),
                          ),
                          DataCell(
                            Text(_value(result, 'ExamScore', 'examScore')),
                          ),
                          DataCell(
                            Text(
                              grade,
                              style: TextStyle(
                                color: _getGradeColor(grade),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _value(Map<String, dynamic> item, String pascalKey, String camelKey) {
    return '${item[pascalKey] ?? item[camelKey] ?? ''}';
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.amber.shade700;
      case 'F':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
