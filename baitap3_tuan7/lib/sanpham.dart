class SanPham {
  String ma;
  String ten;
  double gia;
  double giamGia;

  SanPham({
    required this.ma,
    required this.ten,
    required this.gia,
    required this.giamGia,
  });

  // Tính thuế 10%
  double tinhThue() {
    return gia * 0.1;
  }

  // Xuất thông tin
  String hienThi() {
    return '''
Mã: $ma
Tên: $ten
Giá: $gia
Giảm giá: $giamGia
Thuế: ${tinhThue()}
''';
  }
}