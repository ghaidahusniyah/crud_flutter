class Peminjaman {
  final int id;
  final int userId;
  final int bukuId;
  final String tanggalPinjam;
  final String? tanggalKembali;
  final String status;
  final String bukuJudul;

  Peminjaman({
    required this.id,
    required this.userId,
    required this.bukuId,
    required this.tanggalPinjam,
    this.tanggalKembali,
    required this.status,
    required this.bukuJudul,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'],
      userId: json['user_id'],
      bukuId: json['buku_id'],
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
      status: json['status'],
      bukuJudul: json['buku_judul'] ?? '',
    );
  }
}