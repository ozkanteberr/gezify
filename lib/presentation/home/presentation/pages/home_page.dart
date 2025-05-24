import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/presentation/calender/calender_page.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/create_route/presentation/route_directed.dart';
import 'package:gezify/presentation/destination/pages/destination_detail_page.dart';
import 'package:gezify/presentation/home/presentation/cubits/category/category_state.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/utils.dart';
import 'package:gezify/presentation/home/presentation/cubits/category/category_bloc.dart';
import 'package:gezify/presentation/home/presentation/cubits/destination/destination_cubit.dart';
import 'package:gezify/presentation/home/presentation/cubits/navigation/navigation_cubit.dart';
import 'package:gezify/presentation/maps/pages/map_screen.dart';
import 'package:gezify/presentation/tools_page/tools_page.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/destination/destination_card.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category/category_selector.dart';
import 'package:gezify/presentation/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    context.read<CategoryCubit>().fetchCategories();
    context.read<DestinationCubit>().loadBestDestinations();
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
                  "Güzel dünyayı",
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
                        text: "Gezify'la ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Keşfet!',
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
              onChanged: (value) {
                context.read<DestinationCubit>().filterDestinations(value);
              },
              decoration: InputDecoration(
                hintText: 'Nereye Gitmek İstersin?',
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

            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded) {
                  final categories = state.categories;
                  final categoryItems = mapToCategoryItems(categories);

                  return CategorySelector(
                    categories: categoryItems,
                    onSelected: (index) {
                      final selectedCategory = categoryItems[index].label;
                      context
                          .read<DestinationCubit>()
                          .fetchDestinationsByCategory(selectedCategory);
                    },
                  );
                } else if (state is CategoryError) {
                  return Center(
                      child: Text(
                          'Kategori yüklenirken hata oluştu: ${state.message}'));
                } else {
                  return SizedBox.shrink();
                }
              },
            ),

            // Kategori seçici

            const SizedBox(height: 20),

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

            BlocBuilder<DestinationCubit, DestinationState>(
              builder: (context, state) {
                if (state is DestinationLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is DestinationLoaded) {
                  final destinations =
                      state.filteredDestinations; // filtrelenmiş veriyi al

                  if (destinations.isEmpty) {
                    return Center(child: Text("Hiçbir sonuç bulunamadı."));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];
                      return DestinationCard(
                        imageUrl: destination.bannerImage,
                        title: destination.title,
                        location: destination.adress,
                        rating: destination.rating,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DestinationDetailPage(
                                  destination: destination),
                            ),
                          );
                        },
                        onAddToRoutePressed: () {
                          context
                              .read<RouteBloc>()
                              .add(AddDestinationToRoute(destination));
                        },
                        onShowOnMapPressed: () {
                          context
                              .read<DestinationCubit>()
                              .selectDestination(destination);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GoogleMapScreen(destination: destination),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is DestinationError) {
                  return Center(child: Text('Hata: ${state.message}'));
                } else {
                  return SizedBox.shrink();
                }
              },
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
