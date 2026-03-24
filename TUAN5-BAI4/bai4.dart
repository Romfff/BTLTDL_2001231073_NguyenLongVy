import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// MODEL
class Product {
  String name;
  double price;

  Product(this.name, this.price);
}

// GLOBAL CART
List<Product> cart = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text("Cửa hàng điện thoại",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              child: Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product("Điện thoại 01", 1000),
    Product("Điện thoại 02", 1200),
    Product("Điện thoại 03", 1500),
    Product("Điện thoại 04", 3000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cửa hàng điện thoại"),
        backgroundColor: Colors.orange,
      ),
      drawer: buildDrawer(context),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.phone_iphone),
              title: Text(products[index].name),
              subtitle: Text("${products[index].price} \$"),
              trailing: ElevatedButton(
                child: Text("Đặt"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Xác nhận"),
                      content: Text(
                          "Bạn muốn mua ${products[index].name}?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Không")),
                        TextButton(
                          onPressed: () {
                            cart.add(products[index]);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đã thêm vào giỏ")),
                            );
                          },
                          child: Text("Đồng ý"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CartScreen()),
          );
        },
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, size: 50),
                Text("Vỹ Nguyễn Long"),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text("Cửa hàng"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Giỏ hàng"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Thoát"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeItem(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Xác nhận"),
        content: Text("Xóa sản phẩm khỏi giỏ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Không")),
          TextButton(
            onPressed: () {
              setState(() {
                cart.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Đồng ý"),
          ),
        ],
      ),
    );
  }

  void checkout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Thanh toán"),
        content: Text("Bạn đã thanh toán thành công!"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                cart.clear();
              });
              Navigator.pop(context);
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng của bạn"),
        backgroundColor: Colors.orange,
      ),
      body: cart.isEmpty
          ? Center(child: Text("Bạn chưa có sản phẩm nào"))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cart[index].name),
                  subtitle: Text("${cart[index].price} \$"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => removeItem(index),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: cart.isEmpty ? null : checkout,
          child: Text("Thanh toán"),
        ),
      ),
    );
  }
}