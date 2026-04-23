import 'package:flutter/material.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MusicPlayerPage(),
    );
  }
}

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;
  double _sliderValue = 0.4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.repeat() : _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3B125C), Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'ALBUM',
                style: TextStyle(color: Colors.white54, letterSpacing: 4, fontSize: 12),
              ),
              const Spacer(),
              RotationTransition(
                turns: _controller,
                child: Container(
                  width: 270,
                  height: 270,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.pinkAccent.withOpacity(0.2), blurRadius: 40, spreadRadius: 5)
                    ],
                    border: Border.all(color: Colors.white12, width: 8),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?w=400'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Stay with Me',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                'MIKI MATSUBARA',
                style: TextStyle(color: Colors.purpleAccent, fontSize: 14, letterSpacing: 2),
              ),
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbColor: Colors.pinkAccent,
                        activeTrackColor: Colors.pinkAccent,
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        onChanged: (v) => setState(() => _sliderValue = v),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.skip_previous, color: Colors.black54, size: 30),
                        const Icon(Icons.favorite, color: Colors.pinkAccent, size: 26),
                        GestureDetector(
                          onTap: _handlePlayPause,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(color: Colors.pinkAccent, shape: BoxShape.circle),
                            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 30),
                          ),
                        ),
                        const Icon(Icons.share, color: Colors.black54, size: 26),
                        const Icon(Icons.skip_next, color: Colors.black54, size: 30),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openPlaylist(context),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38, size: 36),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _openPlaylist(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('DANH SÁCH BÀI HÁT', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, i) => ListTile(
                  leading: Text('${i + 1}.', style: const TextStyle(color: Colors.white24)),
                  title: Text('Bài hát mẫu số ${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                  trailing: const Text('3:45 |', style: TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}