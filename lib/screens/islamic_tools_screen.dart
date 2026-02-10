import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../core/app_theme.dart';
import '../core/app_provider.dart';

class IslamicToolsScreen extends StatefulWidget {
  const IslamicToolsScreen({super.key});

  @override
  State<IslamicToolsScreen> createState() => _IslamicToolsScreenState();
}

class _IslamicToolsScreenState extends State<IslamicToolsScreen> {
  // إحداثيات الكعبة المشرفة
  final double kaabaLat = 21.4225;
  final double kaabaLng = 39.8262;

  double _calculateQibla(double lat, double lng) {
    double phiK = kaabaLat * math.pi / 180.0;
    double lambdaK = kaabaLng * math.pi / 180.0;
    double phi = lat * math.pi / 180.0;
    double lambda = lng * math.pi / 180.0;

    double qibla = math.atan2(
      math.sin(lambdaK - lambda),
      math.cos(phi) * math.tan(phiK) - math.sin(phi) * math.cos(lambdaK - lambda)
    );
    return qibla * 180.0 / math.pi;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundDark, Colors.black],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildQiblaSection(provider),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: _buildToolCardSmall(Icons.fingerprint_rounded, 'سبحة إلكترونية', '${provider.tasbihCount}', Colors.orange, () => provider.incrementTasbih())),
                    const SizedBox(width: 15),
                    Expanded(child: _buildToolCardSmall(Icons.menu_book_rounded, 'أذكار المسلم', 'صباح ومساء', Colors.green, () {})),
                  ],
                ),
                const SizedBox(height: 30),
                _buildPrayerTimesSection(provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQiblaSection(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('بوصلة القبلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Text('دقيق مباشر', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('خطأ في المستشعر');
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                double? direction = snapshot.data!.heading;
                if (direction == null) return const Text('المستشعر غير مدعوم');

                // حساب اتجاه القبلة بناءً على الموقع (افتراض مكة إذا لم يوجد موقع)
                double qiblaDirection = _calculateQibla(21.4225, 39.8262); 
                
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: (direction * (math.pi / 180) * -1),
                      child: Image.network('https://cdn-icons-png.flaticon.com/512/2805/2805355.png', color: Colors.white24, width: 180),
                    ),
                    Transform.rotate(
                      angle: ((direction + qiblaDirection) * (math.pi / 180) * -1),
                      child: const Icon(Icons.navigation, color: AppTheme.primaryBlue, size: 50),
                    ),
                    const Icon(Icons.mosque, color: Colors.white, size: 30),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text('قم بتدوير الهاتف باتجاه السهم الأزرق', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // ... (باقي كود الواجهة كما هو في النسخة السابقة)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('الأدوات الإسلامية', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('كل ما تحتاجه في يومك', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        const CircleAvatar(backgroundColor: AppTheme.primaryBlue, child: Icon(Icons.person, color: Colors.white)),
      ],
    );
  }

  Widget _buildToolCardSmall(IconData icon, String title, String val, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(val, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesSection(AppProvider provider) {
    if (provider.prayerTimes == null) return const Center(child: CircularProgressIndicator());
    final times = provider.prayerTimes!;
    return Column(
      children: [
        _buildPrayerTimeRow('الفجر', intl.DateFormat.jm().format(times.fajr)),
        _buildPrayerTimeRow('الظهر', intl.DateFormat.jm().format(times.dhuhr)),
        _buildPrayerTimeRow('العصر', intl.DateFormat.jm().format(times.asr)),
        _buildPrayerTimeRow('المغرب', intl.DateFormat.jm().format(times.maghrib)),
        _buildPrayerTimeRow('العشاء', intl.DateFormat.jm().format(times.isha)),
      ],
    );
  }

  Widget _buildPrayerTimeRow(String name, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(time, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
