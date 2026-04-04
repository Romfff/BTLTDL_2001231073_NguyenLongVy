import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  // Fake database (lưu tài khoản)
  Map<String, String> users = {};

  // Đăng ký
  void register() {
    String email = emailCtrl.text;
    String pass = passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      showMsg("Nhập đầy đủ thông tin");
      return;
    }

    if (users.containsKey(email)) {
      showMsg("Tài khoản đã tồn tại");
    } else {
      users[email] = pass;
      showMsg("Đăng ký thành công");
    }
  }

  // Đăng nhập
  void login() {
    String email = emailCtrl.text;
    String pass = passCtrl.text;

    if (users[email] == pass) {
      showMsg("Đăng nhập thành công");
    } else {
      showMsg("Sai tài khoản hoặc mật khẩu");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email
              const Align(
                  alignment: Alignment.centerLeft, child: Text("Email")),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(hintText: "Value"),
              ),

              const SizedBox(height: 15),

              // Password
              const Align(
                  alignment: Alignment.centerLeft, child: Text("Password")),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: "Value"),
              ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: login,
                    child: const Text("Sign in"),
                  ),
                  ElevatedButton(
                    onPressed: register,
                    child: const Text("Register"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}