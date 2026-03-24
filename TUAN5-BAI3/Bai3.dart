import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Bai3Screen(),
    debugShowCheckedModeBanner: false,
  ));
}

class Bai3Screen extends StatelessWidget {
  final List<Map<String, String>> vouchers = [
    {
      "title": "CGV",
      "desc": "Đồng giá 79K khi mua vé CGV",
    },
    {
      "title": "Giảm 100K",
      "desc": "Cho đơn từ 0đ",
    },
    {
      "title": "Tặng 100K",
      "desc": "Khi mở thẻ VIB Online Plus",
    },
    {
      "title": "Hoàn 15K",
      "desc": "Cho hóa đơn từ 3.000.000đ",
    },
    {
      "title": "Giảm 10K",
      "desc": "Cho đơn từ 100K",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quà của Vinh"),
        backgroundColor: Colors.pink,
        leading: Icon(Icons.arrow_back),
      ),
      body: Column(
        children: [
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                filterChip("Sắp xếp"),
                filterChip("Dịch vụ"),
                filterChip("Gần tôi"),
                filterChip("Yêu thích"),
              ],
            ),
          ),

          SizedBox(height: 10),

         
          Expanded(
            child: ListView.builder(
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink[100],
                      child: Icon(Icons.card_giftcard, color: Colors.pink),
                    ),
                    title: Text(
                      vouchers[index]["title"]!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(vouchers[index]["desc"]!),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: Text("Dùng ngay"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: Chip(
        label: Text(text),
      ),
    );
  }
}