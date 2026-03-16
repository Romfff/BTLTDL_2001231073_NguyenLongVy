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
  bool _isPlaying = false;
  double _progress = 0.18;
  final Duration _duration = const Duration(minutes: 4, seconds: 22);

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes);
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _topButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Icon(icon, color: Colors.black87),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.grey[700], size: 20),
    );
  }

  Widget _controlButton(IconData icon, {bool large = false, VoidCallback? onTap}) {
    final size = large ? 66.0 : 50.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, size: large ? 32 : 26, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topButton(Icons.arrow_back),
                  const Text('PLAYLIST', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w600, fontSize: 16)),
                  _topButton(Icons.menu),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: Container(
                            color: Colors.blueGrey.shade400,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://images.unsplash.com/photo-1499084732479-de2c02d45fc4?auto=format&fit=crop&w=800&q=80',
                                  fit: BoxFit.cover,
                                ),
                                Container(color: Colors.black26),
                                const Center(
                                  child: Icon(Icons.music_note, size: 68, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Kota The Friend', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Birdie', style: TextStyle(color: Colors.black54, fontSize: 14)),
                                Icon(Icons.favorite, color: Colors.redAccent, size: 24),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('0:00', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                Text(_formatDuration(_duration), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                            Slider(
                              value: _progress,
                              onChanged: (value) {
                                setState(() {
                                  _progress = value;
                                });
                              },
                              activeColor: Colors.green,
                              inactiveColor: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _iconButton(Icons.shuffle),
                                _iconButton(Icons.repeat),
                                _iconButton(Icons.queue_music),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _controlButton(Icons.skip_previous),
                                _controlButton(_isPlaying ? Icons.pause : Icons.play_arrow, large: true, onTap: _togglePlay),
                                _controlButton(Icons.skip_next),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
