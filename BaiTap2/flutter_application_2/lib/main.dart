import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Giới thiệu trường',
    'Giới thiệu giáo viên',
    'Giới thiệu sinh viên',
  ];

  static final List<Widget> _pages = <Widget>[
    Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Đại học Công thương TP.HCM',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Được thành lập năm 1976, Đại học Công thương TP. Hồ Chí Minh là một trong những trường đại học hàng đầu về kinh tế, quản lý và kỹ thuật tại miền Nam.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Cơ sở vật chất:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Thư viện với hơn 300.000 đầu sách.\n'
              '- Phòng thí nghiệm hiện đại cho công nghệ thông tin, điện tử, logistics.\n'
              '- Ký túc xá, sân thể thao, khuôn viên xanh mát.\n'
              '- Hệ thống phòng học điều hòa và Wi-Fi toàn trường.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Đội ngũ giảng viên',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Trường có hơn 1.000 giảng viên, trong đó có nhiều giáo sư, phó giáo sư, tiến sĩ và chuyên gia đầu ngành.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Tiêu chí:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Chất lượng giảng dạy cao.\n'
              '- Kinh nghiệm thực tiễn và nghiên cứu khoa học.\n'
              '- Tư vấn học tập và định hướng nghề nghiệp cho sinh viên.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Sinh viên nhà trường',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Sinh viên Đại học Công thương năng động, sáng tạo và gắn kết cộng đồng.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Hoạt động tiêu biểu:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- Câu lạc bộ học thuật và kỹ năng.\n'
              '- Thực tập doanh nghiệp, hội thảo nghề nghiệp.\n'
              '- Nhiều giải thưởng Olympic, khởi nghiệp, nghiên cứu khoa học.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_titles[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Trường'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Giáo viên'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sinh viên'),
        ],
      ),
    );
  }
}
