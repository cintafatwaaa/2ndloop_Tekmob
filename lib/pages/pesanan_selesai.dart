import 'package:flutter/material.dart';

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header toko
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/header-toko.png',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      "TOKO KELONTONG OFFICIAL",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(166, 142, 115, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: const Text("+ Ikuti"),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.settings,
                        color: Color.fromRGBO(166, 142, 115, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Produk",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 2,
                          width: 80,
                          color: Colors.transparent, // tidak ada garis
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Produk",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 2,
                          width: 80,
                          color: Colors.brown, // garis bawah aktif
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 1,
                  height: 1,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tab Menunggu Konfirmasi & Selesai
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFA68E73)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          'Menunggu Konfirmasi',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFA68E73),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          'Selesai',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // List Pesanan
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  PesananItem(
                    image: 'assets/images/kaos-hitam.png',
                    namaProduk: 'Kaos Hitam',
                    harga: 'Rp 100.000',
                    total: 'Rp 56.000',
                  ),
                  SizedBox(height: 12),
                  PesananItem(
                    image: 'assets/images/sepatu-vans.png',
                    namaProduk: 'Vans',
                    harga: 'Rp 250.000',
                    total: 'Rp 56.000',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(166, 142, 115, 0.9),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            BottomIcon(icon: Icons.home, label: 'Home'),
            BottomIcon(icon: Icons.shopping_cart, label: 'Shop'),
            BottomIcon(icon: Icons.store, label: 'Seller'),
            BottomIcon(
              icon: Icons.person,
              label: 'Profil',
              active: false,
            ),
          ],
        ),
      ),
    );
  }
}

class PesananItem extends StatelessWidget {
  final String image;
  final String namaProduk;
  final String harga;
  final String total;

  const PesananItem({
    super.key,
    required this.image,
    required this.namaProduk,
    required this.harga,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Detail Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Rincian Produk",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text(namaProduk),
                const Text("Total Pembayaran"),
                const SizedBox(height: 6),
              ],
            ),
          ),

          // Harga
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 16),
              Text(harga,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                total,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomIcon({
    super.key,
    required this.icon,
    required this.label,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: active
                ? Colors.white
                : const Color.fromRGBO(129, 120, 120, 1)),
        Text(
          label,
          style: TextStyle(
            color: active
                ? Colors.white
                : const Color.fromRGBO(129, 120, 120, 1),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
