class ForkliftRentData {
  final int idPenyewaan;
  final int idForklift;
  final int idPenyewa;
  final String namaPenyewa;
  final String merkForklift;
  final int kapasitasForklift;
  final String tanggalSewa;
  final int lamaSewa;
  final int totalBiaya;
  final int hargaSewa;
  final String alamat;
  final String noTelp;

  ForkliftRentData({
    required this.idPenyewaan,
    required this.idForklift,
    required this.idPenyewa,
    required this.namaPenyewa,
    required this.merkForklift,
    required this.kapasitasForklift,
    required this.tanggalSewa,
    required this.lamaSewa,
    required this.totalBiaya,
    required this.hargaSewa,
    required this.alamat,
    required this.noTelp,
  });

  factory ForkliftRentData.fromJson(Map<String, dynamic> json) {
    return ForkliftRentData(
      idPenyewaan: json['id_penyewaan'],
      idForklift: json['id_forklift'],
      idPenyewa: json['id_penyewa'],
      namaPenyewa: json['nama_penyewa'],
      merkForklift: json['merk_forklift'],
      kapasitasForklift: json['kapasitas_forklift'],
      tanggalSewa: json['tanggal_sewa'],
      lamaSewa: json['lama_sewa'],
      totalBiaya: json['total_biaya'],
      hargaSewa: json['harga_sewa'],
      alamat: json['alamat'],
      noTelp: json['no_telp'],
    );
  }
}