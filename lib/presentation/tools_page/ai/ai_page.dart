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
  }

  void _signInAnonymously() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        print('Anonim giriş başarılı: ${userCredential.user!.uid}');
      } catch (e) {
        print('Anonim giriş hatası: $e');
      }
    } else {
      print('Zaten giriş yapılmış: ${user.uid}');
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
      await doc.reference.delete();
    }

    print("Tüm mesajlar silindi.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gemini Chatbot'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Sohbeti sil',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Sohbeti sil'),
                  content: Text('Tüm sohbet geçmişi silinsin mi?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Sil'),
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, index) {
                    final msg = docs[index];
                    final isUser = msg['sender'] == 'user';
                    return ListTile(
                      title: Align(
                        alignment:
                            isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg['text']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Mesajınızı yazın'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
