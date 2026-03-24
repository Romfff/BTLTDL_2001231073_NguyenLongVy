import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Bai1Screen(),
    debugShowCheckedModeBanner: false,
  ));
}

class Bai1Screen extends StatelessWidget {
  final List<String> categories = ["Đồ án", "KLKS", "Luận văn", "Khác"];

  final List<Map<String, String>> majors = [
    {
      "title": "Công nghệ phần mềm",
      "desc": "Phát triển các ứng dụng giải quyết các vấn đề thực tế"
    },
    {
      "title": "Hệ thống thông tin",
      "desc": "Phát triển các kỹ thuật xử lý thông tin"
    },
    {
      "title": "Mạng máy tính",
      "desc": "Xử lý các vấn đề liên quan đến mạng"
    },
    {
      "title": "An toàn thông tin",
      "desc": "Thiết kế bảo mật hệ thống"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView Demo"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Chọn loại đề tài",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),

         
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Chọn chuyên ngành thực hiện",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),

         
          Expanded(
            child: ListView.builder(
              itemCount: majors.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text(
                      majors[index]["title"]!,
                      style: TextStyle(color: Colors.red),
                    ),
                    subtitle: Text(majors[index]["desc"]!),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}