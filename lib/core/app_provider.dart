import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AppProvider extends ChangeNotifier {
  // --- Audio Player ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _currentSura = "سورة الرحمن";
  String _currentReciter = "مشاري راشد العفاسي";
  
  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String get currentSura => _currentSura;
  String get currentReciter => _currentReciter;

  // --- Tasbih ---
  int _tasbihCount = 0;
  int get tasbihCount => _tasbihCount;

  // --- Prayer Times ---
  PrayerTimes? _prayerTimes;
  PrayerTimes? get prayerTimes => _prayerTimes;
  String _locationName = "جاري التحديد...";
  String get locationName => _locationName;

  // --- Khatmah ---
  int _targetDays = 30;
  int _readPages = 76;
  int get targetDays => _targetDays;
  int get readPages => _readPages;
  double get khatmahProgress => (_readPages / 604);

  AppProvider() {
    _initAudio();
    _loadData();
    updateLocationAndPrayers();
  }

  void _initAudio() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _tasbihCount = prefs.getInt('tasbihCount') ?? 0;
    _targetDays = prefs.getInt('targetDays') ?? 30;
    _readPages = prefs.getInt('readPages') ?? 0;
    notifyListeners();
  }

  // --- Audio Logic ---
  Future<void> playSura(String url, String suraName, String reciterName) async {
    try {
      _currentSura = suraName;
      _currentReciter = reciterName;
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void togglePlay() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  // --- Tasbih Logic ---
  void incrementTasbih() {
    _tasbihCount++;
    _saveInt('tasbihCount', _tasbihCount);
    notifyListeners();
  }

  void resetTasbih() {
    _tasbihCount = 0;
    _saveInt('tasbihCount', _tasbihCount);
    notifyListeners();
  }

  // --- Prayer Times Logic ---
  Future<void> updateLocationAndPrayers() async {
    try {
      Position position = await _determinePosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.shafi;
      
      _prayerTimes = PrayerTimes.today(coordinates, params);
      _locationName = "موقعك الحالي"; 
      
      // تفعيل التنبيهات فور حساب المواقيت
      await NotificationService.schedulePrayerNotifications(_prayerTimes!);
      
      notifyListeners();

    } catch (e) {
      _locationName = "مكة المكرمة (افتراضي)";
      final coordinates = Coordinates(21.4225, 39.8262);
      final params = CalculationMethod.umm_al_qura.getParameters();
      _prayerTimes = PrayerTimes.today(coordinates, params);
      notifyListeners();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  // --- Khatmah Logic ---
  void updateTargetDays(int days) {
    _targetDays = days;
    _saveInt('targetDays', _targetDays);
    notifyListeners();
  }

  void addPage() {
    if (_readPages < 604) {
      _readPages++;
      _saveInt('readPages', _readPages);
      notifyListeners();
    }
  }

  // --- Helpers ---
  Future<void> _saveInt(String key, int val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, val);
  }

  // --- Tafsir ---
  String _currentTafsir = "جاري تحميل التفسير...";
  String get currentTafsir => _currentTafsir;

  Future<void> fetchTafsir(int suraId) async {
    _currentTafsir = "جاري تحميل التفسير...";
    notifyListeners();
    try {
      // نستخدم API القرآن الكريم لجلب تفسير الميسر للسورة
      // ملاحظة: هذا مثال لجلب أول آية، ويمكن تطويره لجلب كامل السورة
      final response = await http.get(Uri.parse('https://api.quran.com/api/v4/tafsirs/16/by_ayah/$suraId:1'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentTafsir = data['tafsir']['text'];
        // تنظيف النص من أكواد HTML إذا وجدت
        _currentTafsir = _currentTafsir.replaceAll(RegExp(r'<[^>]*>|&?nbsp;'), '');
      } else {
        _currentTafsir = "تعذر تحميل التفسير حالياً.";
      }
    } catch (e) {
      _currentTafsir = "تفسير الميسر: هداية ورحمة للمتقين الذين يخافون الله ويؤمنون بالغيب...";
    }
    notifyListeners();
  }

}
