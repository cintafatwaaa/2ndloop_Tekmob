import 'package:flutter/material.dart';

class Produk {
  final String toko;
  final String deskripsi;
  final String gambar;
  final int harga;
  final int bayar;
  final String bukti;

  Produk({
    required this.toko,
    required this.deskripsi,
    required this.gambar,
    required this.harga,
    required this.bayar,
    required this.bukti,
  });
}

class VerifikasiPage extends StatefulWidget {
  const VerifikasiPage({super.key});

  @override
  State<VerifikasiPage> createState() => _VerifikasiPageState();
}

class _VerifikasiPageState extends State<VerifikasiPage> {
  int currentPage = 0;
  static const int itemsPerPage = 3;

  List<Produk> produk = [
    Produk(
      toko: "Toko Kaos Official",
      deskripsi: "Kaos Putih Polos",
      gambar: "",
      harga: 50000,
      bayar: 50000,
      bukti: "https://wa.me/6281234567890",
    ),
    Produk(
      toko: "Toko Sepatu Maju",
      deskripsi: "Sepatu Vans Hitam",
      gambar: "",
      harga: 250000,
      bayar: 250000,
      bukti: "https://wa.me/6281234567890",
    ),
    Produk(
      toko: "Toko Tas Stylish",
      deskripsi: "Tas Ransel Abu",
      gambar: "",
      harga: 150000,
      bayar: 150000,
      bukti: "https://wa.me/6281234567890",
    ),
    Produk(
      toko: "Toko Kemeja",
      deskripsi: "Kemeja Kotak",
      gambar: "",
      harga: 80000,
      bayar: 80000,
      bukti: "https://wa.me/6281234567890",
    ),
    Produk(
      toko: "Toko Celana",
      deskripsi: "Celana Cargo",
      gambar: "",
      harga: 120000,
      bayar: 120000,
      bukti: "https://wa.me/6281234567890",
    ),
  ];

  List<Produk> riwayat = [];

  @override
  Widget build(BuildContext context) {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage) > produk.length
        ? produk.length
        : startIndex + itemsPerPage;
    final currentItems = produk.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA68E73),
        title: const Text(
          "Verifikasi Produk",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Produk (Total: ${produk.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentItems.length,
              itemBuilder: (context, index) {
                final item = currentItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 30),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.toko, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(item.deskripsi),
                                  Text('Harga: Rp ${item.harga}'),
                                  Text('Total: Rp ${item.bayar}', style: const TextStyle(color: Colors.red)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA68E73),
                            ),
                            onPressed: () {
                              setState(() {
                                riwayat.add(item);
                                produk.remove(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Produk berhasil diverifikasi')),
                                );
                              });
                            },
                            child: const Text('Verifikasi'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA68E73),
                  ),
                  child: const Text('Sebelumnya'),
                ),
                ElevatedButton(
                  onPressed: endIndex < produk.length ? () => setState(() => currentPage++) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA68E73),
                  ),
                  child: const Text('Selanjutnya'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
