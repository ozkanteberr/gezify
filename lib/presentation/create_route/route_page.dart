// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final List<String> _routes = [];
  int _counter = 1;

  void _addNewRoute() {
    setState(() {
      _routes.add('Rota $_counter');
      _counter++;
    });
  }

  void _reorderRoutes(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _routes.removeAt(oldIndex);
      _routes.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rota Listeni Oluştur',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Popüler Rotalar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Expanded(
              child: _routes.isEmpty
                  ? const Center(
                      child: Text('Henüz rota eklenmedi',
                          style: TextStyle(color: Colors.grey)))
                  : ReorderableListView.builder(
                      itemCount: _routes.length,
                      onReorder: _reorderRoutes,
                      itemBuilder: (context, index) {
                        return Card(
                          key: ValueKey(_routes[index]), // Unique key ekledik
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: const Icon(Icons.drag_handle,
                                color: Colors.grey),
                            title: Text(_routes[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _routes.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewRoute,
        icon: const Icon(Icons.add),
        label: const Text('Rota Oluştur'),
        backgroundColor: Colors.blue,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}