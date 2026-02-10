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
          // الخلفية المتدرجة (Radial Gradient)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                radialGradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: [
                    AppTheme.primaryBlue.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // شريط الحالة الوهمي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('9:41', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: const [
                          Icon(Icons.signal_cellular_alt, size: 14),
                          SizedBox(width: 5),
                          Icon(Icons.wifi, size: 14),
                          SizedBox(width: 5),
                          Icon(Icons.battery_full, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // إطار الهاتف المركزي
                        Container(
                          width: 250,
                          height: 500,
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundDark,
                            borderRadius: BorderRadius.circular(45),
                            border: Border.all(color: Colors.grey[800]!, width: 8),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: -10,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              // Notch الوهمية
                              Container(
                                width: 120,
                                height: 25,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.menu_book_rounded, size: 50, color: AppTheme.primaryBlue),
                              const SizedBox(height: 10),
                              const Text('بِسْمِ اللَّهِ', style: TextStyle(fontSize: 18, color: Colors.white70)),
                              const Spacer(),
                            ],
                          ),
                        ),
                        
                        // البطاقات العائمة
                        _buildFloatingCard(
                          top: 80, right: -40,
                          icon: Icons.volume_up,
                          color: AppTheme.primaryBlue,
                          title: 'صوتيات',
                          subtitle: 'تلاوات خاشعة',
                        ),
                        _buildFloatingCard(
                          top: 220, left: -50,
                          icon: Icons.auto_stories,
                          color: Colors.amber,
                          title: 'تفسير',
                          subtitle: 'معاني الكلمات',
                        ),
                        _buildFloatingCard(
                          bottom: 100, right: -30,
                          icon: Icons.mosque,
                          color: Colors.emerald,
                          title: 'المواقيت',
                          subtitle: 'تنبيهات دقيقة',
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'كل ما تحتاجه في مكان واحد',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'تطبيق وابر لخدمة كتاب الله الكريم بتجربة عصرية وشاملة',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                
                const SizedBox(height: 40),
                // زر البدء
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 10,
                      shadowColor: AppTheme.primaryBlue.withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('بدء الاستخدام', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_back),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Opacity(
                    opacity: 0.3,
                    child: Text(
                      'POWERED BY WABIR SYSTEMS',
                      style: TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard({
    double? top, double? bottom, double? left, double? right,
    required IconData icon, required Color color,
    required String title, required String subtitle
  }) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
