import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_provider.dart';
import '../core/quran_data.dart';

class QuranReadingScreen extends StatefulWidget {
  final String suraName;
  const QuranReadingScreen({super.key, this.suraName = "سورة البقرة"});

  @override
  State<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends State<QuranReadingScreen> {
  @override
  void initState() {
    super.initState();
    // جلب التفسير عند فتح السورة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final suraId = quranSuras.firstWhere((s) => s['name'] == widget.suraName)['id'];
      Provider.of<AppProvider>(context, listen: false).fetchTafsir(suraId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(widget.suraName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('الجزء ١ • صفحة ٢', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz, color: AppTheme.primaryBlue), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: LinearProgressIndicator(
            value: 0.08,
            backgroundColor: Colors.grey[900],
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.menu_book_rounded, color: AppTheme.primaryBlue),
                      const SizedBox(height: 20),
                      const Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontFamily: 'AmiriQuran', fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'الم ﴿١﴾ ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِلْمُتَّقِينَ ﴿٢﴾ الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ ﴿٣﴾ وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنْزِلَ إِلَيْكَ وَمَا أُنْزِلَ مِنْ قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ ﴿٤﴾ أُولَٰئِكَ عَلَىٰ هُدًى مِنْ رَبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ ﴿٥﴾',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontFamily: 'AmiriQuran', height: 2.5),
                      ),
                      const SizedBox(height: 30),
                      // قسم التفسير الحقيقي
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('تفسير الميسر (تلقائي)', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                                Icon(Icons.auto_fix_high, size: 16, color: AppTheme.primaryBlue),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              provider.currentTafsir,
                              style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 200,
            child: Column(
              children: [
                _buildSideButton(Icons.north),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: const [
                      Text('ص.', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                      Text('٠٢', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildSideButton(Icons.south),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900]?.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomTool(Icons.format_size, 'النمط'),
                  _buildBottomTool(Icons.bookmark_border, 'المحفوظات'),
                  Container(
                    transform: Matrix4.translationValues(0, -25, 0),
                    width: 55, height: 55,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.backgroundDark, width: 4),
                      boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.3), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                  _buildBottomTool(Icons.play_circle_outline, 'استماع'),
                  _buildBottomTool(Icons.translate, 'التفسير'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton(IconData icon) {
    return Container(
      width: 35, height: 35,
      decoration: BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
      child: Icon(icon, size: 18, color: Colors.grey),
    );
  }

  Widget _buildBottomTool(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}
