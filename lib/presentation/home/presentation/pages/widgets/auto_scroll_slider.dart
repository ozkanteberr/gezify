import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AutoScrollSlider extends StatefulWidget {
  const AutoScrollSlider({super.key});

  @override
  State<AutoScrollSlider> createState() => _AutoScrollSliderState();
}

class _AutoScrollSliderState extends State<AutoScrollSlider> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> slides = [
    {
      "image": "assets/images/foto1son.png",
      "title": "Gezmeye hazır mısın?",
      "subtitle": "Gezify’la dünyayı keşfet!"
    },
    {
      "image": "assets/images/foto2son.png",
      "title": "Hayal et, planla, yola çık",
      "subtitle": "Gezify her an yanında!"
    },
    {
      "image": "assets/images/foto3.png",
      "title": "Nereye gidersen git",
      "subtitle": "Yol arkadaşın Gezify!"
    },
    {
      "image": "assets/images/foto4son.png",
      "title": "Gezify’la görünür ol",
      "subtitle": "Reklamın iz bıraksın!"
    },
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _autoScroll);
  }

  void _autoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      int nextPage = (_currentIndex + 1) % slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex = nextPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Arka plan resmi
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(slide["image"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Blur + karartma + yazı
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        color: Colors.black.withOpacity(0.4),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: Stack(
                                children: [
                                  // Stroke efektli yazı
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 24.5,
                                        height: 1.4,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 4
                                          ..color = Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${slide["title"]}\n",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: slide["subtitle"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // İç dolgulu yazı
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 24.5,
                                        height: 1.4,
                                        color: Color(0xFFE8F5F2),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${slide["title"]}\n",
                                          style: const TextStyle(
                                            color: Color(0xFFF9E9C5),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(
                                          text: slide["subtitle"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 184, 233, 191),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔽 SADECE 4. SLAYTTA SAĞ ALTA YAZI EKLE
                    if (index == 3)
                      Positioned(
                        bottom: 8,
                        right: 12,
                        child: Text(
                          "Reklam vermek için iletişime geçiniz.",
                          style: TextStyle(
                            color: const Color.fromARGB(194, 255, 255, 255),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: slides.length,
          effect: WormEffect(
            dotColor: Colors.grey.shade300,
            activeDotColor: const Color(0xFF00796B),
            dotHeight: 10,
            dotWidth: 10,
          ),
        ),
      ],
    );
  }
}
