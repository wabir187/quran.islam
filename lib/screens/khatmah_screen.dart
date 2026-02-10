import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_provider.dart';

class KhatmahScreen extends StatelessWidget {
  const KhatmahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final progress = provider.khatmahProgress;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildHeaderBtn(Icons.arrow_back_ios_new),
        centerTitle: true,
        title: Column(
          children: const [
            Text('حاسبة الختمة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('برمجيات وابر', style: TextStyle(fontSize: 9, color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
        actions: [
          _buildHeaderBtn(Icons.info_outline),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // الإنجاز الحقيقي
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('نسبة الإنجاز', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          Text('${(progress * 100).toStringAsFixed(1)}٪', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('الصفحات المقروءة', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          Text('${provider.readPages} / ٦٠٤', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: Colors.black26,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('"خيركم من تعلم القرآن وعلمه"', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            
            // التحكم بمدة الختمة
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900]?.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('مدة الختمة', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(onPressed: () => provider.updateTargetDays(provider.targetDays - 1), icon: const Icon(Icons.remove, size: 16)),
                          Text(provider.targetDays.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          IconButton(onPressed: () => provider.updateTargetDays(provider.targetDays + 1), icon: const Icon(Icons.add, size: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: provider.targetDays.toDouble(),
                    max: 365, min: 1,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (v) => provider.updateTargetDays(v.toInt()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // إحصائيات واقعية
            Row(
              children: [
                Expanded(child: _buildInfoCard('صفحة يومياً', (604 / provider.targetDays).toStringAsFixed(1), '~ ${(604 / provider.targetDays * 2).toStringAsFixed(0)} دقيقة', AppTheme.primaryBlue)),
                const SizedBox(width: 15),
                Expanded(child: _buildInfoCard('تاريخ الختم المتوقع', 'خلال ${provider.targetDays} يوم', 'تقديري', Colors.white.withOpacity(0.05))),
              ],
            ),
            const SizedBox(height: 25),
            
            const Align(
              alignment: Alignment.centerRight,
              child: Text('توزيع الصفحات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            _buildPrayerCard('كل صلاة تقريباً', '${(604 / provider.targetDays / 5).toStringAsFixed(1)} صفحات', 'لختم القرآن في ${provider.targetDays} يوم', Icons.auto_stories, AppTheme.primaryBlue),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: AppTheme.backgroundDark,
        child: ElevatedButton(
          onPressed: () => provider.addPage(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text('أضف صفحة مقروءة (+1)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildHeaderBtn(IconData icon) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }

  Widget _buildInfoCard(String title, String val, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(sub, style: const TextStyle(fontSize: 9, color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(String name, String pages, String sub, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(sub, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(pages, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
              const Text('بناءً على خطتك', style: TextStyle(fontSize: 9, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
