class Penyewaan {
  final int idPenyewaan;
  final String namaPenyewa;
  final String merkForklift;
  final String kapasitasForklift;
  final String tanggalSewa;
  final int lamaSewa;
  final int totalBiaya;

  Penyewaan({
    required this.idPenyewaan,
    required this.namaPenyewa,
    required this.merkForklift,
    required this.kapasitasForklift,
    required this.tanggalSewa,
    required this.lamaSewa,
    required this.totalBiaya,
  });

  factory Penyewaan.fromJson(Map<String, dynamic> json) {
    return Penyewaan(
      idPenyewaan: json['id_penyewaan'],
      namaPenyewa: json['nama_penyewa'],
      merkForklift: json['merk_forklift'],
      kapasitasForklift: json['kapasitas_forklift'],
      tanggalSewa: json['tanggal_sewa'],
      lamaSewa: json['lama_sewa'],
      totalBiaya: json['total_biaya'],
    );
  }
}
