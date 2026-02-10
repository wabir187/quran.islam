import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sura_list_screen.dart';
import 'screens/audio_player_screen.dart';
import 'screens/islamic_tools_screen.dart';
import 'screens/khatmah_screen.dart';
import 'package:provider/provider.dart';
import 'core/app_provider.dart';
import 'core/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const QuranApp(),
    ),
  );
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بوابة وابر للقرآن الكريم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const OnboardingScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SuraListScreen(),
    const AudioPlayerScreen(),
    const IslamicToolsScreen(),
    const KhatmahScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.backgroundDark,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: Colors.white.withOpacity(0.4),
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'المصحف'),
            BottomNavigationBarItem(icon: Icon(Icons.headphones_rounded), label: 'استماع'),
            BottomNavigationBarItem(icon: Icon(Icons.architecture_rounded), label: 'الأدوات'),
            BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), label: 'الختمة'),
          ],
        ),
      ),
    );
  }
}
