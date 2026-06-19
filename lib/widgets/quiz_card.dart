import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import 'shake_widget.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.question,
    required this.selectedOption,
    required this.success,
    required this.wrongAttemptSignal,
    required this.onOptionSelected,
  });

  final QuizQuestion question;
  final String? selectedOption;
  final bool success;
  final int wrongAttemptSignal;
  final ValueChanged<String> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      trigger: wrongAttemptSignal,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: success ? const Color(0xFF4CAF50) : const Color(0xFFFFFFFF),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4E3AC9).withOpacity(0.16),
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF1B8),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🧠', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pip’s Quiz Time',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF241858),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.3,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3B2F66),
                ),
              ),
              const SizedBox(height: 16),
              ...question.options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _OptionButton(
                    option: option,
                    isSelected: selectedOption == option,
                    isCorrectAnswer: question.isCorrect(option),
                    shouldShowSuccess: success,
                    onTap: () => onOptionSelected(option),
                  ),
                );
              }),
              if (success) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FBE8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Text('🎉', style: TextStyle(fontSize: 26)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Success! Blue was the correct answer.',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF247A35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.option,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.shouldShowSuccess,
    required this.onTap,
  });

  final String option;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool shouldShowSuccess;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCorrectSelected = shouldShowSuccess && isCorrectAnswer;
    final isWrongSelected = isSelected && !isCorrectAnswer && !shouldShowSuccess;

    Color background = const Color(0xFFF7F5FF);
    Color border = const Color(0xFFE0DAFF);
    Color foreground = const Color(0xFF3B2F66);
    IconData icon = Icons.circle_outlined;

    if (isCorrectSelected) {
      background = const Color(0xFFE8FBE8);
      border = const Color(0xFF67C76F);
      foreground = const Color(0xFF247A35);
      icon = Icons.check_circle_rounded;
    } else if (isWrongSelected) {
      background = const Color(0xFFFFF0E8);
      border = const Color(0xFFFFA270);
      foreground = const Color(0xFFC55424);
      icon = Icons.refresh_rounded;
    }

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: shouldShowSuccess ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 2),
          ),
          child: Row(
            children: [
              Icon(icon, color: foreground),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
