import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:gezify/presentation/auth/presentation/cubits/auth_states.dart';
import 'package:gezify/presentation/auth/presentation/pages/sign_in.dart';
import 'package:gezify/presentation/calender/calender_page.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_bloc.dart';
import 'package:gezify/presentation/create_route/bloc/c_route/route_event.dart';
import 'package:gezify/presentation/create_route/presentation/route/route_directed.dart';
import 'package:gezify/presentation/destination/pages/destination_detail_page.dart';
import 'package:gezify/presentation/home/presentation/cubits/category/category_state.dart';
import 'package:gezify/presentation/home/presentation/pages/view_all_page.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/auto_scroll_slider.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/utils.dart';
import 'package:gezify/presentation/home/presentation/cubits/category/category_bloc.dart';
import 'package:gezify/presentation/home/presentation/cubits/destination/destination_cubit.dart';
import 'package:gezify/presentation/home/presentation/cubits/navigation/navigation_cubit.dart';
import 'package:gezify/presentation/maps/pages/map_screen.dart';
import 'package:gezify/presentation/tools_page/tools_page.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/destination/destination_card.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category/category_selector.dart';
import 'package:gezify/presentation/profile/profile_page.dart';

// Renk sabitleri
const Color backgroundColor = Color(0xFFE8F5F2);
const Color primaryGreen = Color(0xFF00796B);
const Color deepGreen = Color.fromRGBO(0, 77, 64, 1);
const Color whiteText = Color.fromARGB(255, 255, 255, 255);
const Color lightGreyText = Color.fromARGB(227, 221, 221, 221);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: deepGreen,
                      backgroundImage: AssetImage("assets/images/avatar.png"),
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
            AutoScrollSlider(),
            const SizedBox(height: 24),
            TextField(
              style: const TextStyle(color: whiteText),
              onChanged: (value) {
                context.read<DestinationCubit>().filterDestinations(value);
              },
              decoration: InputDecoration(
                hintText: 'Nereye Gitmek İstersin?',
                hintStyle: const TextStyle(color: whiteText),
                prefixIcon: const Icon(CupertinoIcons.search, color: whiteText),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                filled: true,
                fillColor: deepGreen,
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
            const SizedBox(height: 20),
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllPage(),
                        ));
                  },
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
                  final destinations = state.filteredDestinations;

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
                          Fluttertoast.showToast(
                            msg: "Rotanıza eklendi!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: primaryGreen,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
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
      backgroundColor: backgroundColor,
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            backgroundColor: primaryGreen,
            selectedItemColor: whiteText,
            unselectedItemColor: lightGreyText,
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
