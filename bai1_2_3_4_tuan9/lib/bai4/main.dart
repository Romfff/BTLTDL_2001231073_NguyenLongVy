import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(SimpleAudioPlayer());
}

class SimpleAudioPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Audio Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: AudioPlayerHome(),
    );
  }
}

class AudioPlayerHome extends StatefulWidget {
  @override
  _AudioPlayerHomeState createState() => _AudioPlayerHomeState();
}

class _AudioPlayerHomeState extends State<AudioPlayerHome> {
  late AudioPlayer _audioPlayer;
  int _currentSongIndex = 0;
  bool _isPlaying = false;

  // Danh sách các file audio trong assets
  final List<String> _songs = [
    'audios/sample1.mp3',
    'audios/sample2.mp3',
    'audios/sample3.mp3',
  ];

  // Tên bài hát để hiển thị
  final List<String> _songTitles = ['Sample Song 1', 'Sample Song 2', 'Sample Song 3'];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Lắng nghe trạng thái phát (đang chạy hay tạm dừng)
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Lắng nghe khi bài hát kết thúc để tự động chuyển bài
    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Phát bài hát
  Future<void> _playSong() async {
    try {
      // AssetSource trong audioplayers mặc định tìm trong thư mục assets/
      // Nên ta truyền đường dẫn tương đối từ sau chữ assets/
      await _audioPlayer.play(AssetSource(_songs[_currentSongIndex]));
    } catch (e) {
      debugPrint("Lỗi khi phát nhạc: $e");
    }
  }

  // Tạm dừng bài hát
  Future<void> _pauseSong() async {
    await _audioPlayer.pause();
  }

  // Dừng bài hát
  Future<void> _stopSong() async {
    await _audioPlayer.stop();
  }

  // Chuyển sang bài tiếp theo
  void _nextSong() {
    setState(() {
      if (_currentSongIndex < _songs.length - 1) {
        _currentSongIndex++;
      } else {
        _currentSongIndex = 0; // Quay lại bài đầu
      }
    });
    _playSong();
  }

  // Quay lại bài trước
  void _previousSong() {
    setState(() {
      if (_currentSongIndex > 0) {
        _currentSongIndex--;
      } else {
        _currentSongIndex = _songs.length - 1; // Chuyển đến bài cuối
      }
    });
    _playSong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Audio Player'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hình ảnh minh họa cho đĩa nhạc
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Icon(
                Icons.music_note,
                size: 100,
                color: Colors.blue[400],
              ),
            ),
            SizedBox(height: 40),
            
            // Hiển thị tên bài hát
            Text(
              _songTitles[_currentSongIndex],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            Text(
              "Playing from Assets",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            
            SizedBox(height: 40),
            
            // Các nút điều khiển
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlBtn(Icons.skip_previous, _previousSong, size: 40),
                SizedBox(width: 20),
                _buildPlayPauseBtn(),
                SizedBox(width: 20),
                _buildControlBtn(Icons.stop, _stopSong, size: 40),
                SizedBox(width: 20),
                _buildControlBtn(Icons.skip_next, _nextSong, size: 40),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget cho nút Play/Pause lớn ở giữa
  Widget _buildPlayPauseBtn() {
    return GestureDetector(
      onTap: () {
        if (_isPlaying) {
          _pauseSong();
        } else {
          _playSong();
        }
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget cho các nút chuyển bài và stop
  Widget _buildControlBtn(IconData icon, VoidCallback onPressed, {double size = 30}) {
    return IconButton(
      icon: Icon(icon),
      iconSize: size,
      color: Colors.blueGrey,
      onPressed: onPressed,
    );
  }
}