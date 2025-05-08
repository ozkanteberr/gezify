// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gezify/common/widgets/app_bar.dart';
import 'package:gezify/presentation/auth/domain/entities/app_user.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_up.dart';
import 'package:gezify/presentation/calender/calender_page.dart';
import 'package:gezify/presentation/create_route/route_directed.dart';
import 'package:gezify/presentation/home/presentation/cubits/navigation_cubit.dart';
import 'package:gezify/presentation/home/presentation/pages/messages_page.dart';
import 'package:gezify/presentation/home/presentation/pages/profile_page.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/destination_card.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category_selector.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category_item.dart';

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
        return const MessagesPage();
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
                  icon: const Icon(Icons.notifications_none),
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
                Text(
                  'Explore the',
                  style: const TextStyle(
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
                prefixIcon: const Icon(Icons.search),
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
                CategoryItem(label: "Tarihi Yerler", iconPath: ""),
                CategoryItem(label: "Müzeler", iconPath: ""),
                CategoryItem(label: "Deniz / Sahil", iconPath: ""),
                CategoryItem(label: "Doğa / Orman", iconPath: ""),
                CategoryItem(
                    label: " Yerel Lezzetler / Restoranlar", iconPath: ""),
                CategoryItem(label: "Dini Mekanlar", iconPath: ""),
              ],
              selectedColor: Colors.blue,
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
            Column(
              children: [
                DestinationCard(
                  imageUrl: 'assets/images/app_logo.png',
                  title: 'Hirosima Place Tokyo',
                  location: 'Tokyo, Japan',
                  rating: 4.8,
                  onTap: () {
                    // Tıklandığında yapılacak işlem
                  },
                ),
                DestinationCard(
                  imageUrl: 'assets/images/trabzon.jpg',
                  title: 'Seoul Garden',
                  location: 'South Korea',
                  rating: 4.6,
                  onTap: () {},
                ),
                DestinationCard(
                  imageUrl: 'assets/images/uzungöl.jpg',
                  title: 'Golden Temple',
                  location: 'India',
                  rating: 4.9,
                  onTap: () {},
                ),
              ],
            )
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
                  icon: Icon(Icons.home), label: 'Ana Sayfa'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: 'Takvim'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), label: 'Mesajlar'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profil'),
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
