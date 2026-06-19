import 'package:flutter/material.dart';

import '../controllers/story_quiz_controller.dart';

class PrimaryStoryButton extends StatelessWidget {
  const PrimaryStoryButton({
    super.key,
    required this.audioState,
    required this.onPressed,
  });

  final AudioState audioState;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isBusy = audioState == AudioState.preparing || audioState == AudioState.speaking;
    final label = switch (audioState) {
      AudioState.preparing => 'Preparing voice...',
      AudioState.speaking => 'Reading story...',
      AudioState.error => 'Retry Story',
      AudioState.completed => 'Read Again',
      AudioState.idle => 'Read Me a Story',
    };

    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B55FF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF8D80E8),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isBusy
              ? Row(
                  key: ValueKey(label),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ],
                )
              : Row(
                  key: ValueKey(label),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.volume_up_rounded),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
