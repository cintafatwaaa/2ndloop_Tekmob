import 'package:flutter/material.dart';

class DataSellerPage extends StatelessWidget {
  DataSellerPage({super.key});

  final List<Map<String, dynamic>> users = [
    {
      'nama': 'Toko Kelonotong',
      'email': 'apaja@mail.com',
      'telepon': '081234567890',
      'alamat': 'Jl. Merdeka No. 1',
      'status': true,
      'riwayat': [
        {'produk': 'Kamera Bekas', 'harga': 300000},
        {'produk': 'Radio Tua', 'harga': 150000},
      ],
    },
    {
      'nama': 'SerbaMurah',
      'email': 'tralelotralala@mail.com',
      'telepon': '082345678901',
      'alamat': 'Jl. Sudirman No. 22',
      'status': false,
      'riwayat': [
        {'produk': 'Sepeda Lipat', 'harga': 450000},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFA68E73),
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'assets/images/logo-2ndloop.png',
                  height: 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data Pengguna',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final bool isActive = user['status'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.account_circle,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['nama'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(user['email']),
                                  Text(user['telepon']),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isActive
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isActive ? 'Aktif' : 'Tidak Aktif',
                                style: TextStyle(
                                  color:
                                      isActive
                                          ? Colors.green
                                          : Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: Text('Profil ${user['nama']}'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Email: ${user['email']}'),
                                              Text(
                                                'Telepon: ${user['telepon']}',
                                              ),
                                              Text('Alamat: ${user['alamat']}'),
                                              Text(
                                                isActive
                                                    ? 'Status: Aktif'
                                                    : 'Status: Tidak Aktif',
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Tutup'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFA68E73,
                                ).withAlpha(220),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Lihat Data'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: Text(
                                          'Riwayat Pesanan - ${user['nama']}',
                                        ),
                                        content: SingleChildScrollView(
                                          child: DataTable(
                                            columns: const [
                                              DataColumn(label: Text('Produk')),
                                              DataColumn(label: Text('Harga')),
                                            ],
                                            rows:
                                                (user['riwayat'] as List)
                                                    .map<DataRow>(
                                                      (item) => DataRow(
                                                        cells: [
                                                          DataCell(
                                                            Text(
                                                              item['produk']
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              'Rp ${item['harga']}',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Tutup'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFA68E73,
                                ).withAlpha(220),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Riwayat'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
