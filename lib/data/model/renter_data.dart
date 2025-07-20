class RenterData {
  final int? idPenyewa;
  final String namaPenyewa;
  final String noTelp;
  final String alamat;

  RenterData({
    required this.idPenyewa,
    required this.namaPenyewa,
    required this.noTelp,
    required this.alamat,
  });

  factory RenterData.fromJson(Map<String, dynamic> json) {
    return RenterData(
      idPenyewa: json['id_penyewa'],
      namaPenyewa: json['nama_penyewa'],
      noTelp: json['no_telp'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_penyewa': idPenyewa,
      'nama_penyewa': namaPenyewa,
      'no_telp': noTelp,
      'alamat': alamat,
    };
  }
}
