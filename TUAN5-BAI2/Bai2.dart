import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Bai2Screen(),
    debugShowCheckedModeBanner: false,
  ));
}

class Bai2Screen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {"icon": Icons.send, "title": "Chuyển tiền"},
    {"icon": Icons.phone_android, "title": "Nạp tiền"},
    {"icon": Icons.receipt, "title": "Thanh toán"},
    {"icon": Icons.flash_on, "title": "Điện"},
    {"icon": Icons.water_drop, "title": "Nước"},
    {"icon": Icons.wifi, "title": "Internet"},
    {"icon": Icons.tv, "title": "Truyền hình"},
    {"icon": Icons.more_horiz, "title": "Xem thêm"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MoMo UI"),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: features.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(features[index]["icon"], color: Colors.pink),
                      SizedBox(height: 5),
                      Text(features[index]["title"],
                          textAlign: TextAlign.center)
                    ],
                  );
                },
              ),
            ),

            
            Container(
              margin: EdgeInsets.all(10),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Sự kiện đang diễn ra",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            
            ListTile(
              title: Text("MoMo đề xuất"),
            ),

            
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(5, (index) {
                  return Container(
                    width: 80,
                    margin: EdgeInsets.all(8),
                    color: Colors.pink[100],
                    child: Center(child: Text("Item $index")),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}