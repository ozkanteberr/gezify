import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
      appBar: AppBar(
        title: const Text('Görünüm ve Dil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: 400, // responsive için kısıtlı genişlik
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tema Seçimi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildThemeOption(
                icon: Icons.light_mode,
                label: 'Açık',
                value: ThemeMode.light,
              ),
              _buildThemeOption(
                icon: Icons.dark_mode,
                label: 'Koyu',
                value: ThemeMode.dark,
              ),
              _buildThemeOption(
                icon: Icons.settings_suggest,
                label: 'Sistem Varsayılanı',
                value: ThemeMode.system,
              ),
              const SizedBox(height: 30),
              const Text(
                'Uygulama Dili',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // locale değişimi burada yapılmalı
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.language),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({required IconData icon, required String label, required ThemeMode value}) {
    return RadioListTile<ThemeMode>(
      value: value,
      groupValue: _themeMode,
      onChanged: (ThemeMode? newValue) {
        setState(() {
          _themeMode = newValue!;
          // tema değişimi globalde uygulanmalı
        });
      },
      title: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
