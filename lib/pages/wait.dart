import 'package:flutter/material.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header gambar toko + foto profil
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/header-toko.png',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Positioned(
                  bottom: -35,
                  left: 20,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/images/logo-toko.png'),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // Info toko
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Toko Kelontong Official",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          "@apapun@gmail.com",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Color.fromRGBO(120, 118, 118, 100),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.location_on, size: 14, color: Colors.red),
                            SizedBox(width: 4),
                            Text("Yogyakarta", style: TextStyle(fontSize: 8)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "⭐ 4.9/5.0 | 1.237 Pengikut | 112 Mengikuti",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(166, 142, 115, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                    child: const Text("+ Ikuti"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.settings,
                      color: Color.fromRGBO(166, 142, 115, 1),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab menu
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(166, 142, 115, 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      alignment: Alignment.center,
                      child: const Text("Menunggu Konfirmasi"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      alignment: Alignment.center,
                      child: const Text("Selesai"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card pesanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/kaos-putih.png',
                        height: 80,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Rincian Produk", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Kaos Putih"),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Pembayaran"),
                              Text("Rp 56.000", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bottom Nav Bar
            Container(
              height: 70,
              margin: const EdgeInsets.fromLTRB(25, 0, 25, 20),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(166, 142, 115, 0.9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, color: Colors.white),
                      Text("Home", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.white),
                      Text("Shop", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.store, color: Colors.white),
                      Text("Seller", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: Color.fromRGBO(129, 120, 120, 1)),
                      Text("Profil", style: TextStyle(color: Color.fromRGBO(129, 120, 120, 1), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
