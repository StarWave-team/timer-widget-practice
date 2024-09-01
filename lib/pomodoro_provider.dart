import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  static const int maxTime = 25 * 60;
  Timer? _timer;

  PomodoroNotifier() : super(PomodoroState(remainingTime: maxTime, isRunning: false));

  void startTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      } else {
        stopTimer();
        resetTimer();
      }
    });
    state = state.copyWith(isRunning: true);
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    state = PomodoroState(remainingTime: maxTime, isRunning: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class PomodoroState {
  final int remainingTime;
  final bool isRunning;

  PomodoroState({required this.remainingTime, required this.isRunning});

  PomodoroState copyWith({int? remainingTime, bool? isRunning}) {
    return PomodoroState(
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

final pomodoroProvider = StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier();
});