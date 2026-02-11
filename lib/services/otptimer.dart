import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class OtpTimerService {
  static final OtpTimerService _instance = OtpTimerService._internal();
  factory OtpTimerService() => _instance;
  OtpTimerService._internal();

  static const String _timerKey = 'otp_timer_end_time';
  static const int _otpDuration = 60; // 60 seconds

  Timer? _timer;
  int _remainingSeconds = 0;
  final List<Function(int)> _listeners = [];

  int get remainingSeconds => _remainingSeconds;
  bool get canResend => _remainingSeconds <= 0;

  /// Start the timer from the beginning (60 seconds)
  Future<void> startTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final endTime = DateTime.now().add(Duration(seconds: _otpDuration));
    await prefs.setInt(_timerKey, endTime.millisecondsSinceEpoch);
    
    _startCountdown();
  }

  /// Resume timer if it's still active
  Future<void> resumeTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeMillis = prefs.getInt(_timerKey);
    
    if (endTimeMillis == null) {
      _remainingSeconds = 0;
      _notifyListeners();
      return;
    }

    final endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
    final now = DateTime.now();
    
    if (now.isAfter(endTime)) {
      // Timer has expired
      _remainingSeconds = 0;
      await prefs.remove(_timerKey);
      _notifyListeners();
    } else {
      // Timer is still active
      _startCountdown();
    }
  }

  /// Reset/clear the timer
  Future<void> resetTimer() async {
    _timer?.cancel();
    _timer = null;
    _remainingSeconds = 0;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_timerKey);
    
    _notifyListeners();
  }

  void _startCountdown() {
    _timer?.cancel();
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final endTimeMillis = prefs.getInt(_timerKey);
      
      if (endTimeMillis == null) {
        _remainingSeconds = 0;
        timer.cancel();
        _notifyListeners();
        return;
      }

      final endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
      final now = DateTime.now();
      
      if (now.isAfter(endTime)) {
        _remainingSeconds = 0;
        await prefs.remove(_timerKey);
        timer.cancel();
        _notifyListeners();
      } else {
        _remainingSeconds = endTime.difference(now).inSeconds;
        _notifyListeners();
      }
    });

    // Immediately update the current remaining time
    _updateRemainingTime();
  }

  Future<void> _updateRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeMillis = prefs.getInt(_timerKey);
    
    if (endTimeMillis == null) {
      _remainingSeconds = 0;
      _notifyListeners();
      return;
    }

    final endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
    final now = DateTime.now();
    
    if (now.isAfter(endTime)) {
      _remainingSeconds = 0;
    } else {
      _remainingSeconds = endTime.difference(now).inSeconds;
    }
    
    _notifyListeners();
  }

  /// Add a listener to be notified when timer updates
  void addListener(Function(int) listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// Remove a listener
  void removeListener(Function(int) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_remainingSeconds);
    }
  }

  /// Clean up resources
  void dispose() {
    _timer?.cancel();
    _listeners.clear();
  }
}