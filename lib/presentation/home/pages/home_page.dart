// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:gezify/common/widgets/app_bar.dart';
import 'package:gezify/presentation/home/pages/widgets/destination_card.dart';
import 'package:gezify/presentation/home/pages/widgets/category_selector.dart';
import 'package:gezify/presentation/home/pages/widgets/category_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Takvim'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mesajlar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
      ),
      body: SafeArea(
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
                        // backgroundImage:
                        // NetworkImage('https://via.placeholder.com/150'),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kullanıcı Adı',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
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
                  CategoryItem(label: " Yerel Lezzetler / Restoranlar", iconPath: ""),
                  CategoryItem(label: "Dini Mekanlar", iconPath: ""),
                ],
                onSelected: (index) => print("Selected index: $index"),
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
      ),
    );
  }
}
