import 'package:flutter/material.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar utama putih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan Akun',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildSectionTitle("Akun"),
                buildItemTile("Ubah Profil"),
                buildSectionTitle("Pengaturan"),
                buildItemTile("Ubah Password"),
                buildItemTile("Bahasa"),
                buildSectionTitle("Bantuan"),
                buildItemTile("Pusat Bantuan"),
                buildItemTile("Hubungi Kami"),
              ],
            ),
          ),
          // Area logout dengan background coklat
          Container(
            width: double.infinity,
            color: const Color(0xFFA68E73),
            padding: const EdgeInsets.symmetric(vertical: 240),
            child: Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi Logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFA68E73),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildItemTile(String title) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, size: 30),
        onTap: () {
          // Tambahkan aksi navigasi kalau perlu
        },
      ),
    );
  }
}