import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordPage extends StatelessWidget {
  static const routeName = '/password';

  // warna krem yang dipakai untuk field & tombol
  static const Color fillColor = Color(0xFFD6CCBC);

  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/menu');
            }
          },
        ),
        title: const Text('Kata Sandi', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      // biar bisa discroll kalau keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* ------------ Kata sandi yang digunakan ------------ */
            const Text(
              'Kata sandi yang digunakan',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),
            _buildPasswordField(),

            const SizedBox(height: 16),

            /* ------------ Kata sandi baru ------------ */
            const Text('Kata sandi baru', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            _buildPasswordField(),

            const SizedBox(height: 16),

            /* ------------ Ulangi kata sandi ------------ */
            const Text('Ulangi kata sandi', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            _buildPasswordField(),

            const SizedBox(height: 15),

            /* ------------ Lupa kata sandi? ------------ */
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to forgot password page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Fitur lupa kata sandi akan segera tersedia',
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Lupa Kata Sandi?'),
              ),
            ),

            const SizedBox(height: 40),

            /* ------------ Tombol Simpan ------------ */
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validate and save password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kata sandi berhasil diubah'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: fillColor,
                  foregroundColor: const Color.fromARGB(255, 7, 7, 7),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ---------- reusable password field ---------- */
  Widget _buildPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fillColor,
        hintText: '••••••••',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
