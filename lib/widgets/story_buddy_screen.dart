import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/story_quiz_controller.dart';
import 'buddy_character.dart';
import 'primary_story_button.dart';
import 'quiz_card.dart';
import 'story_card.dart';

class StoryBuddyScreen extends StatefulWidget {
  const StoryBuddyScreen({super.key});

  @override
  State<StoryBuddyScreen> createState() => _StoryBuddyScreenState();
}

class _StoryBuddyScreenState extends State<StoryBuddyScreen> {
  late final ConfettiController _confettiController;
  bool _playedForCurrentSuccess = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryQuizController>(
      builder: (context, controller, child) {
        if (controller.success && !_playedForCurrentSuccess) {
          _playedForCurrentSuccess = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _confettiController.play();
          });
        }

        if (!controller.success) {
          _playedForCurrentSuccess = false;
        }

        return Scaffold(
          body: Stack(
            children: [
              const _PlayfulBackground(),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final horizontalPadding = constraints.maxWidth > 560 ? 32.0 : 18.0;
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            18,
                            horizontalPadding,
                            28,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _Header(),
                              const SizedBox(height: 18),
                              BuddyCharacter(
                                isHappy: controller.success,
                                isSpeaking: controller.audioState == AudioState.speaking,
                              ),
                              const SizedBox(height: 18),
                              StoryCard(storyText: controller.storyText),
                              const SizedBox(height: 18),
                              PrimaryStoryButton(
                                audioState: controller.audioState,
                                onPressed: controller.canRead ? controller.readStory : null,
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: controller.message == null
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        key: ValueKey(controller.message),
                                        padding: const EdgeInsets.only(top: 14),
                                        child: _MessageBanner(
                                          message: controller.message!,
                                          isError: controller.audioState == AudioState.error,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 18),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 450),
                                switchInCurve: Curves.easeOutBack,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SizeTransition(
                                      sizeFactor: animation,
                                      axisAlignment: -1,
                                      child: child,
                                    ),
                                  );
                                },
                                child: controller.quizVisible
                                    ? QuizCard(
                                        key: const ValueKey('quiz'),
                                        question: controller.quizQuestion,
                                        selectedOption: controller.selectedOption,
                                        success: controller.success,
                                        wrongAttemptSignal: controller.wrongAttemptSignal,
                                        onOptionSelected: controller.chooseOption,
                                      )
                                    : const SizedBox.shrink(key: ValueKey('empty-quiz')),
                              ),
                              if (controller.success) ...[
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: controller.reset,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Play Again'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.04,
                  numberOfParticles: 18,
                  gravity: 0.28,
                  shouldLoop: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.72),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 1.4),
          ),
          child: const Text(
            'Peblo Story Quest',
            style: TextStyle(
              color: Color(0xFF4E3AC9),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'AI Story Buddy',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: Color(0xFF241858),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Listen carefully, then help Pip solve the quiz!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xFF3B2F66).withOpacity(0.76),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFE0DF) : const Color(0xFFE9F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isError ? const Color(0xFFFF8B83) : const Color(0xFF9CD8FF),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(
              isError ? Icons.warning_rounded : Icons.auto_awesome_rounded,
              color: isError ? const Color(0xFFC6423B) : const Color(0xFF1565C0),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isError ? const Color(0xFF84231E) : const Color(0xFF154A80),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayfulBackground extends StatelessWidget {
  const _PlayfulBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFDD82),
            Color(0xFFFFA9A9),
            Color(0xFFC9B6FF),
          ],
        ),
      ),
      child: Stack(
        children: const [
          _Bubble(top: 52, left: -26, size: 120, color: Color(0x66FFFFFF)),
          _Bubble(top: 118, right: -40, size: 160, color: Color(0x55FFFFFF)),
          _Bubble(bottom: 66, left: 26, size: 88, color: Color(0x44FFFFFF)),
          _Bubble(bottom: -30, right: 28, size: 140, color: Color(0x40FFFFFF)),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
