class ForkliftData {
  final int id;
  final String merek;
  final int kapasitas;
  final int hargaSewa;

  ForkliftData({
    required this.id,
    required this.merek,
    required this.kapasitas,
    required this.hargaSewa,
  });

  factory ForkliftData.fromJson(Map<String, dynamic> json) {
    return ForkliftData(
      id: json['id_forklift'],
      merek: json['merk_forklift'],
      kapasitas: json['kapasitas_forklift'],
      hargaSewa: json['harga_sewa'],
    );
  }
}
