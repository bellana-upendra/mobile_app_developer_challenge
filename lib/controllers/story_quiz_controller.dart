import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/quiz_question.dart';

enum AudioState { idle, preparing, speaking, completed, error }

class StoryQuizController extends ChangeNotifier {
  StoryQuizController({
    required this.storyText,
    required this.quizQuestion,
    FlutterTts? flutterTts,
  }) : _tts = flutterTts ?? FlutterTts() {
    _setupTts();
  }

  final String storyText;
  final QuizQuestion quizQuestion;
  final FlutterTts _tts;

  AudioState _audioState = AudioState.idle;
  bool _quizVisible = false;
  bool _success = false;
  String? _selectedOption;
  String? _message;
  int _wrongAttemptSignal = 0;
  bool _isDisposed = false;

  AudioState get audioState => _audioState;
  bool get quizVisible => _quizVisible;
  bool get success => _success;
  String? get selectedOption => _selectedOption;
  String? get message => _message;
  int get wrongAttemptSignal => _wrongAttemptSignal;
  bool get canRead => _audioState != AudioState.preparing && _audioState != AudioState.speaking;

  Future<void> _setupTts() async {
    _tts.setStartHandler(() {
      _safeUpdate(() {
        _audioState = AudioState.speaking;
        _message = 'Pip is reading the story...';
      });
    });

    _tts.setCompletionHandler(() {
      _safeUpdate(() {
        _audioState = AudioState.completed;
        _quizVisible = true;
        _message = 'Great listening! Now answer Pip’s question.';
      });
    });

    _tts.setErrorHandler((message) {
      _safeUpdate(() {
        _audioState = AudioState.error;
        _message = 'Oops! Pip could not read right now. Please try again.';
      });
    });

    _tts.setCancelHandler(() {
      _safeUpdate(() {
        _audioState = AudioState.idle;
        _message = 'Story stopped. Tap the button to try again.';
      });
    });

    try {
      await _tts.setLanguage('en-IN');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.08);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(false);
    } catch (_) {
      _safeUpdate(() {
        _audioState = AudioState.error;
        _message = 'Pip needs a working text-to-speech voice on this device.';
      });
    }
  }

  Future<void> readStory() async {
    if (!canRead) return;

    _audioState = AudioState.preparing;
    _quizVisible = false;
    _success = false;
    _selectedOption = null;
    _message = 'Preparing Pip’s voice...';
    notifyListeners();

    try {
      await _tts.stop();
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (_isDisposed) return;

      final result = await _tts.speak(storyText);
      if (result != 1) {
        _audioState = AudioState.error;
        _message = 'Pip could not start reading. Please retry.';
        notifyListeners();
      }
    } catch (_) {
      _audioState = AudioState.error;
      _message = 'No worries! Pip had a tiny voice problem. Tap retry.';
      notifyListeners();
    }
  }

  Future<void> chooseOption(String option) async {
    if (!_quizVisible || _success) return;

    _selectedOption = option;

    if (quizQuestion.isCorrect(option)) {
      _success = true;
      _message = 'Success! You helped Pip find the shiny blue gear!';
      await HapticFeedback.lightImpact();
      notifyListeners();
      return;
    }

    _wrongAttemptSignal++;
    _message = 'Almost! Listen to the clue and try again.';
    await HapticFeedback.mediumImpact();
    notifyListeners();
  }

  Future<void> reset() async {
    await _tts.stop();
    _audioState = AudioState.idle;
    _quizVisible = false;
    _success = false;
    _selectedOption = null;
    _message = null;
    _wrongAttemptSignal = 0;
    notifyListeners();
  }

  void _safeUpdate(VoidCallback update) {
    if (_isDisposed) return;
    update();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tts.stop();
    super.dispose();
  }
}
