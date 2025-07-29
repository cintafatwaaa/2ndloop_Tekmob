import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ProfilAdmin extends StatelessWidget {
  const ProfilAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> adminData = {
      'nama': 'Admin Barkas',
      'email': 'admin@barkas.com',
      'telepon': '081234567890',
      'alamat': 'Jl. Teknologi No. 42, Yogyakarta',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Navbar Logo
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

            // Judul
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profil Admin',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // Konten Profil
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFA68E73),
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        adminData['nama']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(adminData['email']!),
                      const Divider(height: 32, thickness: 1),
                      _buildInfoRow('Telepon', adminData['telepon']!),
                      const SizedBox(height: 10),
                      _buildInfoRow('Alamat', adminData['alamat']!),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return ElevatedButton.icon(
                              onPressed:
                                  authProvider.isLoading
                                      ? null
                                      : () async {
                                        // Show confirmation dialog
                                        final confirmed = await showDialog<
                                          bool
                                        >(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('Logout'),
                                                content: const Text(
                                                  'Apakah Anda yakin ingin logout?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text('Logout'),
                                                  ),
                                                ],
                                              ),
                                        );

                                        if (confirmed == true) {
                                          await authProvider.signOut();
                                          if (context.mounted) {
                                            context.go('/');
                                          }
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA68E73),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon:
                                  authProvider.isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                              label: Text(
                                authProvider.isLoading
                                    ? 'Logging out...'
                                    : 'Logout',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text('$label:')),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
