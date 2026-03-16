import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Booking UI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F4FF),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8C75FF)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF191A30)),
          bodyMedium: TextStyle(color: Color(0xFF191A30)),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Widget _buildTag(String label, IconData icon, Color bg, Color iconColor) {
    return Container(
      width: 76,
      height: 90,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color.fromRGBO(
              iconColor.red,
              iconColor.green,
              iconColor.blue,
              0.2,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(String name, String role, double rating, Color bg) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFEBE7FF),
            child: Icon(Icons.person, size: 32, color: const Color(0xFF6D5CFF)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFF2C94C), size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            role,
            style: const TextStyle(color: Color(0xFF7A7FAD), fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A7FAD),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Mitch Koko',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1F3D),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5D4FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF6D5CFF)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5FD),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8B3FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.health_and_safety,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'How do you feel?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1F3A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Fill out your medical card right now',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF65668E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D5CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.03),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Color(0xFF7A7FAD)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'How can we help you?',
                          style: TextStyle(
                            color: Color(0xFF7A7FAD),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildTag(
                        'Dentist',
                        Icons.medical_services,
                        const Color(0xFFEAEDFF),
                        const Color(0xFF6D5CFF),
                      ),
                      const SizedBox(width: 12),
                      _buildTag(
                        'Surgeon',
                        Icons.local_hospital,
                        const Color(0xFFE8F7FF),
                        const Color(0xFF00A3FF),
                      ),
                      const SizedBox(width: 12),
                      _buildTag(
                        'Pediatric',
                        Icons.child_care,
                        const Color(0xFFFFF2E9),
                        const Color(0xFFFF8A5B),
                      ),
                      const SizedBox(width: 12),
                      _buildTag(
                        'Pharmacist',
                        Icons.local_pharmacy,
                        const Color(0xFFE8FFE8),
                        const Color(0xFF34C759),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Doctor list',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF6D5CFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildDoctorCard(
                        'Dr. Mitch Koko',
                        'Psychologist 7 y.e.',
                        4.4,
                        Colors.white,
                      ),
                      const SizedBox(width: 12),
                      _buildDoctorCard(
                        'Dr. Steve Jobs',
                        'Surgeon 7 y.e.',
                        5.0,
                        Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
