import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5F2),
      appBar: AppBar(
        title: const Text("İletişim"),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bizimle İletişime Geçin",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F3E46),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Her türlü iş birliği teklifi, sponsorluk ve medya talepleriniz için lütfen aşağıdaki iletişim bilgilerinden bizimle iletişime geçiniz.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6C757D),
              ),
            ),
            const SizedBox(height: 30),
            const ContactInfoTile(
              icon: Icons.email,
              title: "E-posta",
              subtitle: "destek@gezify.com",
            ),
            const SizedBox(height: 16),
            const ContactInfoTile(
              icon: Icons.phone,
              title: "Telefon",
              subtitle: "+90 555 123 4567",
            ),
            const SizedBox(height: 16),
            const ContactInfoTile(
              icon: Icons.location_on,
              title: "Adres",
              subtitle: "Trabzon, Türkiye",
            ),
            const Spacer(),
            Center(
              child: Text(
                "© 2025 Gezify",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ContactInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF004D40),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF2F3E46),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
              ),
            ),
          ],
        )
      ],
    );
  }
}
