import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/presentation/calender/calender_page.dart';
import 'package:gezify/presentation/create_route/presentation/route_directed.dart';
import 'package:gezify/presentation/home/presentation/cubits/destination/destination_cubit.dart';
import 'package:gezify/presentation/home/presentation/cubits/navigation/navigation_cubit.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category/category_item.dart';
import 'package:gezify/presentation/tools_page/tools_page.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/destination/destination_card.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category/category_selector.dart';
import 'package:gezify/presentation/profile_page/profile_page.dart';

class HomePage extends StatefulWidget {
  final void Function()? togglePage;
  const HomePage({super.key, this.togglePage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final authCubit = context.read<AuthCubit>();
  late final navigationCubit = context.read<NavigationCubit>();

  @override
  void initState() {
    super.initState();
    authCubit.checkUser();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const CalendarPage();
      case 2:
        return const RouteDirected();
      case 3:
        return const ToolsPage();
      case 4:
        return const ProfilePage();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst kısım: Profil ve Bildirim
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage("assets/images/user-avatar.png"),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<AuthCubit, AuthStates>(
                      builder: (context, state) {
                        if (state is Authanticated) {
                          return Text(
                            "Hoşgeldin, ${state.user.name}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                          );
                        }
                        return const Text("Hoşgeldin!");
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.bell),
                  onPressed: () async {
                    await context.read<AuthCubit>().logout();
                    if (mounted) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SignInPage(),
                      ));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Başlık yazısı
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore the',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 28),
                    children: [
                      TextSpan(
                        text: 'Beautiful ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'world!',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Arama kutusu
            TextField(
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search something...',
                prefixIcon: const Icon(CupertinoIcons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori seçici
            CategorySelector(
              categories: [
                CategoryItem(label: "Tarihi Yerler", icon: CupertinoIcons.time),
                CategoryItem(label: "Müzeler", icon: CupertinoIcons.book),
                CategoryItem(
                    label: "Deniz / Sahil", icon: CupertinoIcons.brightness),
                CategoryItem(
                    label: "Doğa / Orman",
                    icon: CupertinoIcons.leaf_arrow_circlepath),
                CategoryItem(
                    label: "Yerel Lezzetler / Restoranlar",
                    icon: CupertinoIcons.square_arrow_up_on_square),
                CategoryItem(label: "Dini Mekanlar", icon: CupertinoIcons.moon),
              ],
              selectedColor: Colors.blue,
              unselectedColor: Colors.grey,
              itemRadius: 25,
            ),
            const SizedBox(height: 40),

            // Best Destination başlık
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Best Destination',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View all'),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Aşağı kaydırmalı destinasyonlar
            BlocBuilder<DestinationCubit, DestinationState>(
              builder: (context, state) {
                if (state is DestinationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DestinationLoaded) {
                  return Column(
                    children: state.destinations.map((destination) {
                      return DestinationCard(
                        imageUrl: destination.bannerImage,
                        title: destination.title,
                        location: destination.adress,
                        rating: destination.rating,
                        onTap: () {
                          // Detay sayfasına yönlendirme yapılabilir
                        },
                      );
                    }).toList(),
                  );
                } else if (state is DestinationError) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'Ana Sayfa'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.calendar), label: 'Takvim'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.map), label: 'Rota'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_stack), label: 'Araçlar'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'Profil'),
            ],
            currentIndex: state.index,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              navigationCubit.changeIndex(index);
            },
          );
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return _getPage(state.index);
        },
      ),
    );
  }
}
