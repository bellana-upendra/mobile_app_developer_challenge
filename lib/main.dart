import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/story_quiz_controller.dart';
import 'data/story_data.dart';
import 'models/quiz_question.dart';
import 'theme/app_theme.dart';
import 'widgets/story_buddy_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PebloStoryBuddyApp());
}

class PebloStoryBuddyApp extends StatelessWidget {
  const PebloStoryBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoryQuizController>(
      create: (_) => StoryQuizController(
        storyText: storyText,
        quizQuestion: QuizQuestion.fromJson(quizPayload),
      ),
      child: MaterialApp(
        title: 'Peblo Story Buddy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const StoryBuddyScreen(),
      ),
    );
  }
}
