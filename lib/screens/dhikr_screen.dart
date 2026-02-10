import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class DhikrScreen extends StatelessWidget {
  const DhikrScreen({super.key});

  final List<Map<String, String>> azkar = const [
    {"text": "أَصْبَحْنَا وَأَصْبَحَ المُلْكُ للهِ وَالحَمْدُ للهِ، لاَ إِلَهَ إلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ", "count": "1"},
    {"text": "سُبْحَانَ اللهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ", "count": "3"},
    {"text": "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ", "count": "1"},
    {"text": "رضيت بالله رباً، وبالإسلام ديناً، وبمحمد صلى الله عليه وسلم نبياً", "count": "3"},
    {"text": "يا حي يا قيوم برحمتك أستغيث أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين", "count": "1"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('أذكار الصباح والمساء', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: azkar.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Text(
                  azkar[index]['text']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.8, fontFamily: 'AmiriQuran'),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'التكرار: ${azkar[index]['count']}',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
