import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5F2),
      appBar: AppBar(
        title: const Text('Görünüm ve Dil'),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: const Color(0xFFE8F5F2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Tema Seçimi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F3E46),
            ),
          ),
          const SizedBox(height: 16),

          // Sadece sistem teması gösterilir ve değiştirilemez
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            color: const Color(0xFFD0F0E0),
            child: ListTile(
              leading: const Icon(Icons.settings_suggest, color: Color(0xFF2F3E46)),
              title: const Text(
                'Sistem Varsayılanı',
                style: TextStyle(color: Color(0xFF2F3E46)),
              ),
              trailing: const Icon(Icons.check, color: Color(0xFF004D40)),
            ),
          ),

          const SizedBox(height: 40),
          const Text(
            'Uygulama Dili',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F3E46),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                value: 'tr',
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.language, color: Color(0xFF004D40)),
                ),
                items: const [
                  DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) {
                  if (value == 'en') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFFE8F5F2),
                        title: const Text('Dil Desteği'),
                        content: const Text(
                          'Bu kısım için çalışmalarımız sürüyor.\nLütfen daha sonra tekrar deneyin.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Tamam',
                              style: TextStyle(color: Color(0xFF00796B)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
