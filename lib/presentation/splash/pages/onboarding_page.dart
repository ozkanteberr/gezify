import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/splash11.png",
      "title": "Rotaları Keşfet",
      "desc": "Senin için en uygun gezi rotalarını keşfet ve macerana başla."
    },
    {
      "image": "assets/images/splash2.PNG",
      "title": "Gezdiğin yerler hakkında bilgiler al",
      "desc": "tarihini ve kültürünü öğren"
    },
    {
      "image": "assets/images/splash3.png",
      "title": "Her Zaman Yanında",
      "desc": "Uygulamamız sana her an rehberlik etsin. Hemen başla!"
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 40),
                      // Görsel
                      Image.asset(
                        data["image"]!,
                        height: 300,
                        fit: BoxFit.contain,
                      ),

                      // Başlık ve açıklama
                      Column(
                        children: [
                          Text(
                            data["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data["desc"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Daire içindeki ok butonu
                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 77, 64, 1),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(20),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),

            // Sayfa göstergesi (dot'lar)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Color(0xFF00796B) : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),

            // "Atla" butonu
            Positioned(
              top: 20,
              right: 20,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text("Atla",
                style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(0, 77, 64, 1),
              ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
