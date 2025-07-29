import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              // Gambar background
              Container(
                height: 450,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/bg-hal.png',
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 120,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo-2ndloop.png',
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Positioned(
                bottom: -5,
                left: 0,
                right: 0,
                child: const Text(
                  'Beli Cermat,',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 0), // Mepet ke atas

                  const Text(
                    'Jual Bijak',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  // Deskripsi
                  const Text(
                    'Temukan Barang Bekas Berkualitas Sekarang!',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 80),

                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 166, 142, 115),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: const Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () {
                        context.go('/signup');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 166, 142, 115),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
