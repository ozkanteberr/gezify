import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  final List<Map<String, String>> faqItems = const [
    {
      "question": "Rota nasıl oluşturabilirim?",
      "answer": "Ana ekranda bulunan '+' butonuna basarak yeni bir rota oluşturabilirsiniz.",
    },
    {
      "question": "Arkadaşlarımla rota paylaşabilir miyim?",
      "answer": "Evet, oluşturduğunuz rotaları paylaş menüsünden arkadaşlarınıza gönderebilirsiniz.",
    },
    {
      "question": "Uygulama çevrimdışı çalışıyor mu?",
      "answer": "Bazı temel işlevler çevrimdışı çalışır ancak rota verileri internet bağlantısı gerektirir.",
    },
    {
      "question": "Dil ayarını nasıl değiştirebilirim?",
      "answer": "Profil > Görünüm ve Dil kısmından uygulama dilini değiştirebilirsiniz.",
    },
    {
      "question": "Hesabımı nasıl silebilirim?",
      "answer": "Hesabınızı silmek için destek ekibiyle iletişime geçmeniz gerekir.",
    },
    {
      "question": "Gezify ücretli mi?",
      "answer": "Gezify'in temel özellikleri ücretsizdir. Premium özellikler için abonelik seçenekleri sunulmaktadır.",
    },
    {
      "question": "Şifremi unuttum, ne yapmalıyım?",
      "answer": "Giriş ekranından 'Şifremi Unuttum' seçeneğine tıklayarak şifrenizi sıfırlayabilirsiniz.",
    },
    {
      "question": "Rotalarımı nasıl yedekleyebilirim?",
      "answer": "Hesabınızla giriş yaptığınız sürece rotalarınız bulutta güvenli bir şekilde saklanır.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5F2),
      appBar: AppBar(
        title: const Text('Sıkça Sorulan Sorular'),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: const Color(0xFFE8F5F2),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          final item = faqItems[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.white,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.question_answer, color: Color(0xFF2F3E46)),
                title: Text(
                  item["question"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2F3E46),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      item["answer"]!,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF555555)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
