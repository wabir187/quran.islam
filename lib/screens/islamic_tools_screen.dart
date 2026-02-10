import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qibla/flutter_qibla.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart' as intl;
import '../core/app_theme.dart';
import '../core/app_provider.dart';

class IslamicToolsScreen extends StatelessWidget {
  const IslamicToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final prayers = provider.prayerTimes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('الأدوات الإسلامية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('برمجيات وابر - WABIR', style: TextStyle(fontSize: 10, color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Qibla Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[900]!, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.explore_outlined, color: AppTheme.primaryBlue),
                          SizedBox(width: 10),
                          Text('القبلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // بوصلة حقيقية باستخدام FlutterQibla
                  SizedBox(
                    height: 200,
                    child: StreamBuilder(
                      stream: FlutterQibla.qiblaStream,
                      builder: (_, AsyncSnapshot<QiblaDirection> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final qiblaDirection = snapshot.data!;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // إطار البوصلة
                            Transform.rotate(
                              angle: (qiblaDirection.direction * (math.pi / 180) * -1),
                              child: Container(
                                width: 150, height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[800]!, width: 4),
                                ),
                                child: Stack(
                                  children: [
                                    Align(alignment: Alignment.topCenter, child: Text('ش', style: TextStyle(color: Colors.grey[600], fontSize: 10))),
                                    Align(alignment: Alignment.bottomCenter, child: Text('ج', style: TextStyle(color: Colors.grey[600], fontSize: 10))),
                                  ],
                                ),
                              ),
                            ),
                            // إبرة القبلة
                            Transform.rotate(
                              angle: (qiblaDirection.qibla * (math.pi / 180) * -1),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 4, height: 60, decoration: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(2))),
                                  Container(width: 4, height: 60, decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: AppTheme.backgroundDark, shape: BoxShape.circle, border: Border.all(color: AppTheme.primaryBlue)),
                                child: const Icon(Icons.mosque, size: 12, color: AppTheme.primaryBlue),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(provider.locationName, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            // Tasbih & Azkar
            Row(
              children: [
                Expanded(child: _buildTasbihCard(provider)),
                const SizedBox(width: 15),
                Expanded(child: _buildToolCardSmall(
                  title: 'الأذكار',
                  mainValue: 'أذكار المساء',
                  subLabel: 'ألا بذكر الله تطمئن القلوب',
                  icon: Icons.auto_awesome,
                  color: Colors.amber,
                )),
              ],
            ),
            const SizedBox(height: 20),
            
            // Real Prayer Times
            Container(
              decoration: BoxDecoration(color: Colors.grey[900]!.withOpacity(0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الأذان والمواقيت', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(intl.DateFormat('EEEE, d MMMM', 'ar').format(DateTime.now()), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  if (prayers != null) ...[
                    _buildPrayerTimeRow('الفجر', _formatTime(prayers.fajr), Icons.wb_twilight, false),
                    _buildPrayerTimeRow('الظهر', _formatTime(prayers.dhuhr), Icons.wb_sunny, false),
                    _buildPrayerTimeRow('العصر', _formatTime(prayers.asr), Icons.flare, false),
                    _buildPrayerTimeRow('المغرب', _formatTime(prayers.maghrib), Icons.wb_twilight, false),
                    _buildPrayerTimeRow('العشاء', _formatTime(prayers.isha), Icons.dark_mode, false),
                  ] else
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return intl.DateFormat('hh:mm a', 'ar').format(time.toLocal());
  }

  Widget _buildTasbihCard(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('السبحة الإلكترونية', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => provider.resetTasbih(), icon: const Icon(Icons.refresh, size: 14, color: Colors.grey), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          ),
          const SizedBox(height: 15),
          Text(provider.tasbihCount.toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
          const Text('سبحان الله', style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => provider.incrementTasbih(),
            child: Container(width: 50, height: 50, decoration: const BoxDecoration(color: AppTheme.primaryBlue, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCardSmall({required String title, required String mainValue, required String subLabel, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)), Icon(icon, size: 14, color: color)],
          ),
          const SizedBox(height: 15),
          Text(mainValue, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(subLabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.05), foregroundColor: color, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 10), textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [Text('فتح الأذكار'), Icon(Icons.arrow_back, size: 12)]),
          )
        ],
      ),
    );
  }

  Widget _buildPrayerTimeRow(String name, String time, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: isActive ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: isActive ? AppTheme.primaryBlue : Colors.grey[700], shape: BoxShape.circle)), const SizedBox(width: 15), Text(name, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? AppTheme.primaryBlue : Colors.white))]),
          Row(children: [Text(time, style: TextStyle(color: isActive ? AppTheme.primaryBlue : Colors.grey, fontSize: 14)), const SizedBox(width: 15), Icon(icon, size: 18, color: isActive ? AppTheme.primaryBlue : Colors.grey[700])]),
        ],
      ),
    );
  }
}
