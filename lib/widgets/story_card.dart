import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key, required this.storyText});

  final String storyText;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 1.6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4E3AC9).withOpacity(0.14),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text('📖', style: TextStyle(fontSize: 24)),
                SizedBox(width: 8),
                Text(
                  'Today’s Mini Story',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF241858),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              storyText,
              style: const TextStyle(
                fontSize: 18,
                height: 1.45,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3B2F66),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
