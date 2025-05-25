import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'gemini_service.dart';

class AiPage extends StatefulWidget {
  @override
  _AiPageState createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final _controller = TextEditingController();
  final _geminiService = GeminiService();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _signInAnonymously();
    _initializeWelcomeMessage();
  }

  void _initializeWelcomeMessage() async {
    final messages = await FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp')
        .get();

    if (messages.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': 'Merhaba! Sana nasıl yardımcı olabilirim?',
        'sender': 'bot',
        'timestamp': Timestamp.now(),
      });
    }
  }

  void _signInAnonymously() async {
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        await FirebaseAuth.instance.signInAnonymously();
      } catch (e) {
        print('Anonim giriş hatası: $e');
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'sender': 'user',
      'timestamp': Timestamp.now(),
    });

    _controller.clear();

    final reply = await _geminiService.sendMessage(text);

    await FirebaseFirestore.instance.collection('messages').add({
      'text': reply,
      'sender': 'bot',
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _deleteAllMessages() async {
    final collection = FirebaseFirestore.instance.collection('messages');
    final snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      final text = doc['text'];
      if (text != 'Merhaba! Sana nasıl yardımcı olabilirim?') {
        await doc.reference.delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),
        iconTheme: const IconThemeData(
          color: Color(0xFFE8F5F2), // ← Geri tuşu rengi burada tanımlanıyor
        ),
        title: const Text(
          'Gemini Chatbot',
          style: TextStyle(color: Color(0xFFE8F5F2)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFE8F5F2)),
            tooltip: 'Sohbeti sil',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFFD9F2EC),
                  title: const Text('Sohbeti sil'),
                  content: const Text('Tüm sohbet geçmişi silinsin mi?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('İptal',
                          style: TextStyle(color: Color(0xFF004D40))),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Sil',
                          style: TextStyle(color: Color(0xFFB71C1C))),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _deleteAllMessages();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF004D40)));
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: docs.length,
                    itemBuilder: (ctx, index) {
                      final msg = docs[index];
                      final isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser)
                              Padding(
                                padding: const EdgeInsets.only(top:37,right: 8.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage('assets/images/ai.png'),
                                  backgroundColor: const Color(0xFFE8F5F2),
                                  
                                ),
                              ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color(0xFFB2DFDB)
                                      : const Color(0xFFD9F2EC),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft:
                                        Radius.circular(isUser ? 16 : 0),
                                    bottomRight:
                                        Radius.circular(isUser ? 0 : 16),
                                  ),
                                ),
                                child: Text(
                                  msg['text'],
                                  style: const TextStyle(
                                      color: Color(0xFF004D40), fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: const Color(0xFFD9F2EC),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Color(0xFF004D40)),
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      hintStyle: const TextStyle(color: Color(0xFF004D40)),
                      filled: true,
                      fillColor: const Color(0xFFE0F2F1),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF004D40),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
