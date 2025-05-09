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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sıkça Sorulan Sorular'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqItems.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = faqItems[index];
          return ExpansionTile(
            leading: const Icon(Icons.question_answer),
            title: Text(item["question"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(item["answer"]!),
              ),
            ],
          );
        },
      ),
    );
  }
}
