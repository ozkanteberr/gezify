import 'package:flutter/material.dart';
import 'package:gezify/presentation/home/domain/entities/destination.dart'; // örnek yol

class DestinationDetailPage extends StatelessWidget {
  final Destination destination;

  const DestinationDetailPage({Key? key, required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Burada destination verisini kullanarak detay sayfasını oluşturulur.
    return Scaffold(
      appBar: AppBar(title: Text(destination.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(destination.bannerImage),
            SizedBox(height: 12),
            Text(destination.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(destination.adress,
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 8),
            Text('Rating: ${destination.rating}'),
            SizedBox(height: 12),
            Text(''), // description varsa göster
          ],
        ),
      ),
    );
  }
}
