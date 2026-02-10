import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_provider.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.2,
            colors: [Color(0xFF1A3D8F), AppTheme.backgroundDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGlassButton(Icons.expand_more),
                    Column(
                      children: [
                        const Text('يُشغل الآن', style: TextStyle(fontSize: 10, color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        Text(provider.currentSura, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    _buildGlassButton(Icons.more_vert),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('القراء', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                          Text('عرض الكل', style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildReciterAvatar(provider, 'العفاسي', 'https://server8.mp3quran.net/afs/114.mp3', 'الناس', 'مشاري العفاسي'),
                          _buildReciterAvatar(provider, 'عبد الباسط', 'https://server7.mp3quran.net/basit/114.mp3', 'الناس', 'عبد الباسط عبد الصمد'),
                          _buildReciterAvatar(provider, 'السديس', 'https://server11.mp3quran.net/sds/114.mp3', 'الناس', 'عبد الرحمن السديس'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220, height: 220,
                    child: StreamBuilder<Duration?>(
                      stream: provider.audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = provider.audioPlayer.duration ?? Duration.zero;
                        return CircularProgressIndicator(
                          value: duration.inSeconds > 0 ? position.inSeconds / duration.inSeconds : 0,
                          strokeWidth: 6,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                        );
                      }
                    ),
                  ),
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(provider.currentSura.split(' ').last, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('سورة حقيقية', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.5)),
                        const SizedBox(height: 15),
                        if (provider.isPlaying)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 3, height: [10, 20, 15, 25, 12][i].toDouble(),
                              decoration: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(2)),
                            )),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              Text(provider.currentReciter, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('بث مباشر من MP3Quran', style: TextStyle(color: Colors.grey, fontSize: 13)),
              
              const Spacer(),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.shuffle, color: Colors.grey),
                        Row(
                          children: [
                            IconButton(icon: const Icon(Icons.skip_next_rounded, size: 40, color: Colors.white), onPressed: () {}),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => provider.togglePlay(),
                              child: Container(
                                width: 70, height: 70,
                                decoration: const BoxDecoration(color: AppTheme.primaryBlue, shape: BoxShape.circle),
                                child: Icon(provider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 40, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(icon: const Icon(Icons.skip_previous_rounded, size: 40, color: Colors.white), onPressed: () {}),
                          ],
                        ),
                        const Icon(Icons.repeat, color: AppTheme.primaryBlue),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton(IconData icon) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Icon(icon, color: Colors.grey, size: 20),
    );
  }

  Widget _buildReciterAvatar(AppProvider provider, String name, String url, String sura, String reciterFull) {
    bool isActive = provider.currentReciter.contains(name);
    return GestureDetector(
      onTap: () => provider.playSura(url, sura, reciterFull),
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isActive ? AppTheme.primaryBlue : Colors.transparent, width: 2)),
              child: CircleAvatar(radius: 25, backgroundColor: Colors.grey[800], child: const Icon(Icons.person, color: Colors.grey)),
            ),
            const SizedBox(height: 5),
            Text(name, style: TextStyle(fontSize: 9, color: isActive ? Colors.white : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
