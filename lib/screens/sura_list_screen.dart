import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/quran_data.dart';
import 'quran_reading_screen.dart';

class SuraListScreen extends StatefulWidget {
  const SuraListScreen({super.key});

  @override
  State<SuraListScreen> createState() => _SuraListScreenState();
}

class _SuraListScreenState extends State<SuraListScreen> {
  List<Map<String, dynamic>> filteredSuras = quranSuras;
  final TextEditingController _searchController = TextEditingController();

  void _filterSuras(String query) {
    setState(() {
      filteredSuras = quranSuras
          .where((sura) =>
              sura['name'].contains(query) ||
              sura['englishName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('المصحف الشريف', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // شريط البحث الفاخر
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSuras,
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryBlue),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredSuras.length,
              itemBuilder: (context, index) {
                final sura = filteredSuras[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuranReadingScreen(suraName: sura['name'])));
                    },
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), shape: BoxShape.circle),
                      child: Center(child: Text(sura['id'].toString(), style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12))),
                    ),
                    title: Text(sura['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'AmiriQuran')),
                    subtitle: Text('${sura['verses']} آيات • ${sura['type']}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    trailing: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
