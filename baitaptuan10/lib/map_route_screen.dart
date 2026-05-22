import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class MapRouteScreen extends StatefulWidget {
  const MapRouteScreen({super.key});

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  
  LatLng _currentLocation = const LatLng(10.8231, 106.6297); // Tọa độ mặc định
  LatLng? _destinationLocation;
  List<LatLng> _routePoints = [];
  
  // Thông tin thêm từ API định tuyến
  String _distance = "0 km";
  String _duration = "0 phút";
  bool _isLoading = false;
  
  // Loại phương tiện mặc định: driving (ô tô), walking (đi bộ), bike (xe đạp/xe máy)
  String _selectedVehicle = "driving"; 
  
  // Biến SQLite Database
  Database? _database;
  List<Map<String, dynamic>> _favoriteRoutes = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _initDatabase();
  }

  // --- 1. KHỞI TẠO SQLITE DATABASE ---
  Future<void> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'favorites.db');

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Favorites (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, lat REAL, lng REAL)');
    });
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (_database == null) return;
    final List<Map<String, dynamic>> maps = await _database!.query('Favorites');
    setState(() {
      _favoriteRoutes = maps;
    });
  }

  Future<void> _addFavorite(String name, LatLng target) async {
    if (_database == null) return;
    await _database!.insert('Favorites', {
      'name': name,
      'lat': target.latitude,
      'lng': target.longitude,
    });
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu vào danh sách yêu thích!')),
    );
  }

  // --- 2. ĐỊNH VỊ GPS HIỆN TẠI ---
  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation, 15.0);
    });
  }

  // --- 3. TÌM KIẾM ĐỊA CHỈ VĂN BẢN (Geocoding API thay thế) ---
  Future<void> _searchAddress() async {
    if (_searchController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      // Dùng API miễn phí Nominatim của OpenStreetMap để dịch địa chỉ -> tọa độ
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(_searchController.text)}&format=json&limit=1');
      
      final response = await http.get(url, headers: {'User-Agent': 'huit_map_app'});
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);
          
          setState(() {
            _destinationLocation = LatLng(lat, lon);
            _mapController.move(_destinationLocation!, 14.0);
          });
          _findRoute();
        } else {
          _showSnackBar('Không tìm thấy địa chỉ này!');
        }
      }
    } catch (e) {
      _showSnackBar('Lỗi tìm kiếm địa chỉ: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- 4. TÌM ĐƯỜNG ĐI + KHOẢNG CÁCH + THỜI GIAN + PHƯƠNG TIỆN ---
  Future<void> _findRoute() async {
    if (_destinationLocation == null) return;
    setState(() => _isLoading = true);

    // Áp dụng loại phương tiện tương ứng với OSRM Router
    String osrmProfile = 'driving';
    if (_selectedVehicle == 'walking') osrmProfile = 'foot';
    if (_selectedVehicle == 'bike') osrmProfile = 'bicycle';

    try {
      final url = Uri.parse(
          'https://router.project-osrm.org/route/v1/$osrmProfile/'
          '${_currentLocation.longitude},${_currentLocation.latitude};${_destinationLocation!.longitude},${_destinationLocation!.latitude}'
          '?overview=full&geometries=geojson');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final List<dynamic> coordinates = geometry['coordinates'];

          // Lấy khoảng cách (mét -> km) và thời gian (giây -> phút)
          double distanceKm = route['distance'] / 1000;
          double durationMin = route['duration'] / 60;

          setState(() {
            _distance = "${distanceKm.toStringAsFixed(2)} km";
            _duration = "${durationMin.toStringAsFixed(0)} phút";
            _routePoints = coordinates
                .map((coord) => LatLng(coord[1] as double, coord[0] as double))
                .toList();
          });
        }
      }
    } catch (e) {
      _showSnackBar('Lỗi kết nối định tuyến: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HUIT Map Advanced', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Nút xem danh sách yêu thích lưu từ SQLite
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: _showFavoritesBottomSheet,
          )
        ],
      ),
      body: Stack(
        children: [
          // Giao diện bản đồ chính
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 14.0,
              // TÍNH NĂNG: Cho phép nhấn giữ (Long Press) để chọn điểm đích trên bản đồ
              onLongPress: (tapPosition, point) {
                setState(() {
                  _destinationLocation = point;
                });
                _findRoute();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.map_navigator_app',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(points: _routePoints, color: Colors.blue.shade700, strokeWidth: 5.0),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                  ),
                  if (_destinationLocation != null)
                    Marker(
                      point: _destinationLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 35),
                    ),
                ],
              ),
            ],
          ),

          // KHUNG ĐIỀU KHIỂN NÂNG CAO (Gồm Ô tìm kiếm và Chọn phương tiện)
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Column(
              children: [
                // 1. Thanh tìm kiếm địa chỉ văn bản (Geocoding)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Nhập địa chỉ cần đi (Ví dụ: Quận 1)...',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.blue),
                          onPressed: _searchAddress,
                        ),
                      ),
                      onSubmitted: (_) => _searchAddress(),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // 2. Thanh công cụ chọn Phương tiện di chuyển & Hiển thị kết quả
                Card(
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildVehicleButton(Icons.directions_car, 'driving'),
                            _buildVehicleButton(Icons.directions_bike, 'bike'),
                            _buildVehicleButton(Icons.directions_walk, 'walking'),
                          ],
                        ),
                        const Divider(height: 10),
                        // Hiển thị khoảng cách và thời gian di chuyển thực tế
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Khoảng cách: $_distance', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Thời gian: $_duration', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                        if (_destinationLocation != null) ...[
                          const SizedBox(height: 5),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white),
                            onPressed: () => _addFavorite(_searchController.text.isNotEmpty ? _searchController.text : "Điểm đánh dấu", _destinationLocation!),
                            icon: const Icon(Icons.star),
                            label: const Text('Lưu tuyến đường này'),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // TÍNH NĂNG: Thêm nút lấy vị trí hiện tại làm điểm đích
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              setState(() {
                _destinationLocation = _currentLocation; // Đích trùng vị trí hiện tại
              });
              _showSnackBar("Đã đặt điểm đích trùng vị trí hiện tại!");
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.outlined_flag, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: _determinePosition,
            backgroundColor: Colors.blue.shade800,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget tạo nhanh nút chọn phương tiện
  Widget _buildVehicleButton(IconData icon, String type) {
    bool isSelected = _selectedVehicle == type;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.blue.shade800 : Colors.grey, size: 28),
      onPressed: () {
        setState(() {
          _selectedVehicle = type;
        });
        if (_destinationLocation != null) _findRoute();
      },
    );
  }

  // --- HÀM HIỂN THỊ DANH SÁCH TỪ SQLITE ---
  void _showFavoritesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tuyến đường yêu thích (SQLite)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: _favoriteRoutes.isEmpty
                    ? const Center(child: Text('Chưa có danh mục nào được lưu.'))
                    : ListView.builder(
                        itemCount: _favoriteRoutes.length,
                        itemBuilder: (context, index) {
                          final item = _favoriteRoutes[index];
                          return ListTile(
                            leading: const Icon(Icons.star, color: Colors.orange),
                            title: Text(item['name']),
                            subtitle: Text("${item['lat'].toStringAsFixed(3)}, ${item['lng'].toStringAsFixed(3)}"),
                            onTap: () {
                              setState(() {
                                _destinationLocation = LatLng(item['lat'], item['lng']);
                              });
                              Navigator.pop(context);
                              _findRoute();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}