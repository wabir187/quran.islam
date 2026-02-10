import 'package:flutter/material.dart';
import '../main.dart';
import '../core/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5, -0.6),
                radius: 1.5,
                colors: [Color(0xFF1E3A8A), Color(0xFF101622)],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Phone Mockup (Illustration)
                  Container(
                    height: 350,
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white10, width: 3),
                      boxShadow: [
                        BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 40, spreadRadius: 10)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Container(width: 80, height: 18, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
                          const SizedBox(height: 20),
                          _buildMockCard(Icons.headphones_rounded, "تلاوة خاشعة", "مشاري العفاسي", Colors.blue),
                          _buildMockCard(Icons.translate_rounded, "التفسير الميسر", "لجميع الآيات", Colors.teal),
                          _buildMockCard(Icons.alarm_rounded, "مواقيت الصلاة", "تنبيهات دقيقة", Colors.orange),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  const Text(
                    'بوابة وابر للقرآن الكريم',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'تطبيق متكامل للقراءة، الاستماع، وتتبع الختمة بتصميم عصري وفريد.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.6),
                  ),
                  const SizedBox(height: 40),
                  
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainNavigation()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleChild(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                      ),
                      child: const Text('ابدأ التجربة الآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockCard(IconData icon, String title, String sub, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}

// Helper for Button Shape
class RoundedRectangleChild extends RoundedRectangleBorder {
  const RoundedRectangleChild({super.borderRadius});
}
