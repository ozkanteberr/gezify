import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _themeMode = ThemeMode.system;
  String _selectedLanguage = 'tr';

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
          _buildThemeCard(Icons.light_mode, 'Açık', ThemeMode.light),
          _buildThemeCard(Icons.dark_mode, 'Koyu', ThemeMode.dark),
          _buildThemeCard(
              Icons.settings_suggest, 'Sistem Varsayılanı', ThemeMode.system),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.language, color: Color(0xFF004D40)),
                ),
                items: const [
                  DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });

                  if (value == 'en') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color(0xFFE8F5F2),
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

  Widget _buildThemeCard(IconData icon, String label, ThemeMode mode) {
    final isSelected = _themeMode == mode;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: isSelected ? const Color(0xFFD0F0E0) : Colors.white,
      child: RadioListTile<ThemeMode>(
        value: mode,
        groupValue: _themeMode,
        onChanged: (ThemeMode? newValue) {
          setState(() {
            _themeMode = newValue!;
            // Tema değişimi global olarak uygulanmalı
          });
        },
        activeColor: const Color(0xFF004D40),
        title: Row(
          children: [
            Icon(icon, color: const Color(0xFF2F3E46)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Color(0xFF2F3E46))),
          ],
        ),
      ),
    );
  }
}
