# Peblo Story Buddy – Flutter Intern Challenge

A single-screen, kid-friendly Flutter app for the Peblo Flutter / Swift Developer Intern Challenge.

The app reads a short story aloud using native Text-to-Speech and then reveals a data-driven quiz. A wrong answer shakes the quiz card and gives haptic feedback. A correct answer shows a happy buddy state, success message, and confetti.

## Framework choice

I chose Flutter because the challenge highlights mid-range Android devices around 3GB RAM. Flutter lets us build a smooth Android-first prototype with one clean codebase, while still supporting iOS.

## Features implemented

- Single-screen kid-friendly UI
- Cute placeholder AI Buddy character built with Flutter widgets
- Story text card
- Native TTS narration using `flutter_tts`
- Preparing, speaking, completed, and error states
- Friendly retry message on TTS failure
- Quiz rendered from a JSON-like payload, not hardcoded UI
- Supports 3, 4, 5, or more options without changing widget code
- Quiz appears only after audio completion
- Wrong answer: shake animation + haptic feedback
- Correct answer: success state + happy buddy + confetti
- Provider-based state management
- Lightweight UI with no image assets required

## Project structure

```text
lib/
├── controllers/
│   └── story_quiz_controller.dart
├── data/
│   └── story_data.dart
├── models/
│   └── quiz_question.dart
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── buddy_character.dart
│   ├── primary_story_button.dart
│   ├── quiz_card.dart
│   ├── shake_widget.dart
│   ├── story_buddy_screen.dart
│   └── story_card.dart
└── main.dart
```

## How the audio → quiz transition works

`StoryQuizController` owns the audio state. When the user taps **Read Me a Story**, the app moves to `AudioState.preparing`, then starts native TTS. The `flutter_tts` completion handler changes the state to `AudioState.completed` and sets `quizVisible = true`. The screen listens through Provider and reveals the quiz with `AnimatedSwitcher` and `SizeTransition`.

## How the quiz is data-driven

The quiz data lives in `lib/data/story_data.dart`:

```dart
const Map<String, Object> quizPayload = {
  'question': "What colour was Pip the Robot's lost gear?",
  'options': <String>['Red', 'Green', 'Blue', 'Yellow'],
  'answer': 'Blue',
};
```

`QuizQuestion.fromJson()` parses the payload. The UI uses:

```dart
...question.options.map((option) => _OptionButton(...))
```

So the same renderer works if a backend later sends 3, 4, 5, or more options.

## Caching approach

This version uses device-native TTS, so no remote audio file is downloaded. If ElevenLabs or another remote TTS API is added later, I would cache the generated audio by hashing the story text and storing the file in app cache storage. The app would first check the local cache, play cached audio if available, and only call the API when the cache misses.

## Failure handling

The controller catches TTS setup and speak errors. If speech fails, the UI displays a friendly message and keeps the button enabled for retry. The app does not hang or crash.

## Performance notes for mid-range Android devices

- No heavy raster image assets are used; the buddy is built with simple Flutter widgets.
- Confetti particle count is intentionally limited.
- Provider keeps audio and quiz state in one small `ChangeNotifier`.
- Quiz options are generated from data and only small UI sections rebuild.
- Animations use Flutter's built-in animation system and transform-based shaking.
- For profiling, run in profile mode and capture Flutter DevTools frame timing.

Suggested profiling command:

```bash
flutter run --profile
```

Then open Flutter DevTools → Performance → record the full flow:

1. Tap **Read Me a Story**
2. Wait for audio completion
3. Try a wrong answer
4. Try the correct answer

Expected result: most frames should stay below 16.67ms for 60fps.

## AI usage & judgment note for submission

You can write this honestly in the form/README if allowed by your assignment rules:

> I used AI assistance to plan structure, state handling, and edge cases. I reviewed and changed the output manually. One suggestion I rejected was using a remote ElevenLabs API by default because the challenge targets mid-range Android devices and native TTS is lighter, simpler, and more resilient for this prototype. I also kept the buddy as Flutter UI shapes instead of large image assets to reduce app size and memory usage.

## Setup steps

### 1. Create a Flutter project

```bash
flutter create peblo_story_buddy
cd peblo_story_buddy
```

### 2. Replace files

Copy the provided `pubspec.yaml`, `analysis_options.yaml`, `README.md`, and `lib/` folder into your created Flutter project.

### 3. Install packages

```bash
flutter pub get
```

### 4. Android setup for flutter_tts

Open:

```text
android/app/build.gradle
```

Make sure minimum SDK is at least 21:

```gradle
minSdkVersion 21
```

For Android 11+ package visibility, open:

```text
android/app/src/main/AndroidManifest.xml
```

Add this inside `<manifest>` and before `<application>`:

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.TTS_SERVICE" />
    </intent>
</queries>
```

### 5. Run app

```bash
flutter run
```

### 6. Build APK

```bash
flutter build apk --release
```

APK output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Screen recording checklist

Record this exact flow:

1. Launch app
2. Tap **Read Me a Story**
3. Show preparing/speaking state
4. Wait until quiz appears
5. Tap a wrong answer such as Red
6. Show shake feedback
7. Tap Blue
8. Show success, happy Pip, and confetti

## GitHub submission checklist

- Push the full Flutter project to GitHub
- Add README.md
- Add screen recording link if needed
- Test on Android emulator or Android phone
- Submit GitHub repository link in the Google Form
