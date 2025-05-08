import 'package:flutter/material.dart';

class RouteDetailPage extends StatelessWidget {
  final String routeName;

  const RouteDetailPage({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(routeName)),
      body: Center(
        child: Text(
          '$routeName Detayları',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
