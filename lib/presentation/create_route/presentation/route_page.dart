import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_state.dart';
import 'package:gezify/presentation/create_route/presentation/route_detail.dart';

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RouteBloc(),
      child: const RouteView(),
    );
  }
}

class RouteView extends StatefulWidget {
  const RouteView({super.key});

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  final TextEditingController _routeTitleController = TextEditingController();
  bool _isPrivate = false;

  @override
  void dispose() {
    _routeTitleController.clear();
    _isPrivate = false;
    super.dispose();
  }

  void _saveRoutes(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final title = _routeTitleController.text.trim();

    if (uid != null && title.isNotEmpty) {
      context.read<RouteBloc>().add(
            SaveDestinationsToFirebase(
              uid: uid,
              listTitle: title,
            ),
          );

      context.read<RouteBloc>().add(ClearDestinations());
      _routeTitleController.clear();
      setState(() {
        _isPrivate = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rota listesi kaydedildi.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen başlık girin.")),
      );
    }
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rotalarım',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _routeTitleController,
              decoration: const InputDecoration(
                labelText: "Rota listesi başlığı (ör. Karadeniz Turu)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text("Herkese Açık mı?"),
                    const SizedBox(width: 10),
                    Switch(
                      value: !_isPrivate,
                      onChanged: (value) {
                        setState(() {
                          _isPrivate = !value;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const DestinationMiniListPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Rota ekle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  if (state.routes.isEmpty) {
                    return const Center(
                      child: Text('Henüz rota eklenmedi',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.routes.length,
                    itemBuilder: (context, index) {
                      final destination = state.routes[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(destination.title),
                          subtitle: Text(destination.adress),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => context
                                .read<RouteBloc>()
                                .add(RemoveDestinationFromRoute(index)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _saveRoutes(context),
              icon: const Icon(Icons.save),
              label: const Text('Rotaları Kaydet'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
