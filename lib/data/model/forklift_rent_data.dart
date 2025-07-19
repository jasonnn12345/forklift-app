class ForkliftRentData {
  final int idPenyewaan;
  final int idForklift;
  final String namaPenyewa;
  final String merkForklift;
  final String kapasitasForklift;
  final String tanggalSewa;
  final int lamaSewa;
  final int totalBiaya;

  ForkliftRentData({
    required this.idPenyewaan,
    required this.idForklift,
    required this.namaPenyewa,
    required this.merkForklift,
    required this.kapasitasForklift,
    required this.tanggalSewa,
    required this.lamaSewa,
    required this.totalBiaya,
  });

  factory ForkliftRentData.fromJson(Map<String, dynamic> json) {
    return ForkliftRentData(
      idPenyewaan: json['id_penyewaan'],
      idForklift: json['id_forklift'],
      namaPenyewa: json['nama_penyewa'],
      merkForklift: json['merk_forklift'],
      kapasitasForklift: json['kapasitas_forklift'],
      tanggalSewa: json['tanggal_sewa'],
      lamaSewa: json['lama_sewa'],
      totalBiaya: json['total_biaya'],
    );
  }
}
