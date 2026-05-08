import 'package:flutter/material.dart';

void main() {
  runApp(const MultimediaApp());
}

class MultimediaApp extends StatelessWidget {
  const MultimediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multimedia App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC5CAE9),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Multimedia App',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Main App!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            
            // Danh sách các bài tập
            _buildMenuItem(
              context,
              title: 'Bài 1: SMS Reader',
              subtitle: 'Đọc tin nhắn SMS từ thiết bị',
              icon: Icons.chat_bubble,
              iconColor: Colors.teal,
              onTap: () => _navigateTo(context, const SMSReaderScreen()),
            ),
            _buildMenuItem(
              context,
              title: 'Bài 1: Contacts Reader',
              subtitle: 'Đọc danh bạ từ thiết bị',
              icon: Icons.contact_mail,
              iconColor: Colors.blue,
              onTap: () => _navigateTo(context, const ContactsReaderScreen()),
            ),
            _buildMenuItem(
              context,
              title: 'Bài 2 & 3: Quản lý Danh Bạ',
              subtitle: 'Thêm danh bạ + lưu vào SQLite (có dữ liệu mẫu)',
              icon: Icons.person_add_alt_1,
              iconColor: Colors.orange,
              onTap: () => _navigateTo(context, const ContactManagementScreen()),
            ),
            _buildMenuItem(
              context,
              title: 'Bài 4: Quản lý Danh Bạ (Xóa/Sửa/Tìm kiếm)',
              subtitle: 'Thêm, sửa, xóa, tìm kiếm danh bạ trong SQLite',
              icon: Icons.manage_accounts,
              iconColor: Colors.deepPurple,
              onTap: () => _navigateTo(context, const ContactManagementScreen(isAdvanced: true)),
            ),
            _buildMenuItem(
              context,
              title: 'Bài 5: SMS Analyzer',
              subtitle: 'Thống kê, lọc quảng cáo, OTP từ SMS',
              icon: Icons.analytics,
              iconColor: Colors.redAccent,
              onTap: () => _navigateTo(context, const SMSAnalyzerScreen()),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class SMSReaderScreen extends StatelessWidget {
  const SMSReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockSms = [
      {'sender': '0901234567', 'body': 'Ma xac thuc OTP cua ban la 123456.'},
      {'sender': 'Shopee', 'body': 'Don hang cua ban dang tren duong giao.'},
      {'sender': 'Ngan Hang', 'body': 'Tai khoan chuyen khoan -500,000VND.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('SMS Reader')),
      body: ListView.builder(
        itemCount: mockSms.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.sms)),
              title: Text(mockSms[index]['sender']!),
              subtitle: Text(mockSms[index]['body']!),
            ),
          );
        },
      ),
    );
  }
}

class ContactsReaderScreen extends StatelessWidget {
  const ContactsReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockContacts = [
      {'name': 'Nguyễn Văn A', 'phone': '0123456789'},
      {'name': 'Trần Thị B', 'phone': '0987654321'},
      {'name': 'Lê Văn C', 'phone': '0909090909'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Reader')),
      body: ListView.builder(
        itemCount: mockContacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text(mockContacts[index]['name']![0])),
            title: Text(mockContacts[index]['name']!),
            subtitle: Text(mockContacts[index]['phone']!),
            trailing: const Icon(Icons.call, color: Colors.green),
          );
        },
      ),
    );
  }
}

class ContactManagementScreen extends StatefulWidget {
  final bool isAdvanced;
  const ContactManagementScreen({super.key, this.isAdvanced = false});

  @override
  State<ContactManagementScreen> createState() => _ContactManagementScreenState();
}

class _ContactManagementScreenState extends State<ContactManagementScreen> {
  // Mô phỏng dữ liệu SQLite
  final List<Map<String, String>> _contacts = [
    {'id': '1', 'name': 'Dữ liệu mẫu 1', 'phone': '0911223344'},
    {'id': '2', 'name': 'Dữ liệu mẫu 2', 'phone': '0922334455'},
  ];
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _searchQuery = "";

  void _addContact() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      setState(() {
        _contacts.add({
          'id': DateTime.now().toString(),
          'name': _nameController.text,
          'phone': _phoneController.text,
        });
        _nameController.clear();
        _phoneController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _deleteContact(String id) {
    setState(() {
      _contacts.removeWhere((c) => c['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = _contacts.where((c) => 
      c['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      c['phone']!.contains(_searchQuery)
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdvanced ? 'Quản lý Danh Bạ (Nâng cao)' : 'Quản lý Danh Bạ'),
      ),
      body: Column(
        children: [
          if (widget.isAdvanced)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm danh bạ...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return ListTile(
                  title: Text(contact['name']!),
                  subtitle: Text(contact['phone']!),
                  trailing: widget.isAdvanced 
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red), 
                            onPressed: () => _deleteContact(contact['id']!)
                          ),
                        ],
                      )
                    : const Icon(Icons.person),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm danh bạ mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Tên')),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Số điện thoại')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(onPressed: _addContact, child: const Text('Lưu')),
        ],
      ),
    );
  }
}

class SMSAnalyzerScreen extends StatelessWidget {
  const SMSAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Analyzer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thống kê tin nhắn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Tổng số', '150', Colors.blue),
                _buildStatCard('Quảng cáo', '45', Colors.orange),
                _buildStatCard('OTP', '12', Colors.green),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Tin nhắn được lọc (OTP)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.security, color: Colors.green),
                    title: Text('Google: 542102 là mã xác minh của bạn.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.security, color: Colors.green),
                    title: Text('VNPAY: Ma OTP cua ban la 999888.'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}