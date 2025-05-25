import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_state.dart';
import 'package:gezify/presentation/create_route/presentation/route/route_detail.dart';
import 'package:gezify/presentation/home/presentation/pages/home_page.dart';

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
        const SnackBar(
                      content: Text(
                        'Rota Listesi Kaydedildi...',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xFF004D40),
                      duration: Duration(seconds: 2),
                    ),
        
        
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
                      content: Text(
                        'Lütfen başlık girin...',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xFF004D40),
                      duration: Duration(seconds: 2),
                    ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5F2),
      appBar: AppBar(
          title: const Text('Rota Listeni Oluştur'),
          centerTitle: true,
          backgroundColor: const Color(0xFF004D40),
          foregroundColor: const Color(0xFFE8F5F2),
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
              decoration: InputDecoration(
                labelText: "Rota listesi başlığı (ör. Karadeniz Turu)",
                labelStyle: TextStyle(
                  color: Color.fromRGBO(0, 77, 64, 1), // ← Label yazı rengi
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 77, 64, 1), // Normal durumdaki kenarlık rengi
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 58, 49, 1), // Odaklanınca kenarlık rengi (daha koyu yeşil)
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
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
                      value: !_isPrivate, //true(value)
                      onChanged: (value) {
                        setState(() {
                          _isPrivate = !value;
                          context.read<RouteBloc>().add(TogglePrivacy(!value));
                        });
                      },
                      activeColor: Colors
                          .white, // ON durumundaki thumb (daire) rengi - yeşil
                      activeTrackColor: Color(
                          0xFF00796B), // ON durumundaki track (arkaplan) rengi
                      inactiveThumbColor: Color.fromRGBO(
                          0, 77, 64, 1), // OFF durumundaki thumb rengi - gri
                      inactiveTrackColor:
                          Color(0xFFE0E0E0), // OFF durumundaki track rengi
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
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text('Rota ekle',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00796B),
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
                          style: TextStyle(color: Color.fromRGBO(
                          0, 77, 64, 1))),
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
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Rotaları Kaydet',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Color(0xFF00796B),
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
