import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final _emailCtrl = TextEditingController(text: 'apaaja@gmail.com');
  final _alamatCtrl = TextEditingController(text: 'Yogyakarta');
  final _tanggalCtrl = TextEditingController();
  final _kontakCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  static const Color fillColor = Color(0xFFA68E73);

  final ImagePicker _picker = ImagePicker();
  XFile? _avatar;

  Future<void> _pickAvatar() async {
    final XFile? img = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null) {
      setState(() => _avatar = img);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              Navigator.pop(context);
            } else {
              context.go('/menu');
            }
          },
        ),
        centerTitle: true,
        title: const Text('Edit Profil', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              // Save profile changes
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil berhasil diperbarui'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            },
            child: const Text('Selesai', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickAvatar,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: ClipOval(
                  child:
                      _avatar != null
                          ? _buildSelectedImage()
                          : _buildDefaultLogo(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toko Kelontong Official',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            _label('Email'),
            _field(controller: _emailCtrl, readOnly: true),

            _label('Alamat'),
            _field(controller: _alamatCtrl),

            _label('Tanggal Lahir'),
            _field(
              controller: _tanggalCtrl,
              readOnly: true,
              suffixIcon: Icons.calendar_today,
              onTap: _selectDate,
            ),

            _label('Kontak'),
            _field(controller: _kontakCtrl, keyboard: TextInputType.phone),

            _label('Bio'),
            _field(controller: _bioCtrl, maxLines: 4),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /* Avatar Builder untuk Web dan Mobile */
  Widget _buildSelectedImage() {
    if (kIsWeb) {
      return Image.network(
        _avatar!.path,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(),
      );
    } else {
      return Image.file(
        File(_avatar!.path),
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(),
      );
    }
  }

  /* Default Avatar jika belum dipilih */
  Widget _buildDefaultLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }

  Widget _label(String text) => Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(top: 16, bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 13)),
  );

  Widget _field({
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
    IconData? suffixIcon,
    TextInputType keyboard = TextInputType.text,
    VoidCallback? onTap,
  }) => TextField(
    controller: controller,
    readOnly: readOnly,
    keyboardType: keyboard,
    maxLines: maxLines,
    onTap: onTap,
    decoration: InputDecoration(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      suffixIcon:
          suffixIcon != null ? Icon(suffixIcon, color: Colors.black87) : null,
    ),
  );

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _tanggalCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _alamatCtrl.dispose();
    _tanggalCtrl.dispose();
    _kontakCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }
}
