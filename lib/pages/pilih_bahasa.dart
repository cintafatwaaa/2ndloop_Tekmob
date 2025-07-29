import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BahasaPage extends StatefulWidget {
  static const routeName = '/bahasa';
  const BahasaPage({super.key});

  @override
  State<BahasaPage> createState() => _BahasaPageState();
}

class _BahasaPageState extends State<BahasaPage> {
  final String _primaryLanguage = 'Bahasa Indonesia';
  String _otherSelected = 'English';

  static const Color fillColor = Color(0xFFD6CCBC); // krem/coklat muda
  static const Color dialogColor = Color(
    0xFFD6CCBC,
  ); // warna dialog juga coklat muda

  final List<String> _languageOptions = [
    'English',
    'Spanish',
    'Arabic',
    'Japanese',
    'Korean',
    'French',
    'Mandarin',
    'German',
    'Hindi',
    'Russian',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Bahasa',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Save language selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bahasa berhasil disimpan: $_otherSelected'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bahasa Utama',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _staticTile(_primaryLanguage),

            const SizedBox(height: 24),

            const Text(
              'Bahasa Lainnya',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _otherLanguageTile(),
          ],
        ),
      ),
    );
  }

  Widget _staticTile(String label) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    decoration: BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  Widget _otherLanguageTile() => InkWell(
    onTap: _showLanguageDialog,
    borderRadius: BorderRadius.circular(4),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_otherSelected, style: const TextStyle(fontSize: 14)),
          const Icon(Icons.chevron_right_rounded, color: Colors.black54),
        ],
      ),
    ),
  );

  void _showLanguageDialog() {
    String tempSelected = _otherSelected;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: dialogColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Pilih Bahasa',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    _languageOptions.map((lang) {
                      return RadioListTile<String>(
                        title: Text(
                          lang,
                          style: const TextStyle(color: Colors.black),
                        ),
                        value: lang,
                        groupValue: tempSelected,
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            _otherSelected = value!;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }
}
