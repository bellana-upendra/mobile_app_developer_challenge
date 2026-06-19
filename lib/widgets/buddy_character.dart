import 'package:flutter/material.dart';

class BuddyCharacter extends StatelessWidget {
  const BuddyCharacter({
    super.key,
    required this.isHappy,
    required this.isSpeaking,
  });

  final bool isHappy;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.96, end: isSpeaking ? 1.04 : 1.0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Semantics(
        label: 'Cute robot story buddy named Pip',
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFD9EEFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6347FF).withOpacity(0.20),
                      blurRadius: 32,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                child: Container(
                  width: 92,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B55FF),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Eye(isHappy: isHappy),
                      const SizedBox(width: 18),
                      _Eye(isHappy: isHappy),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 82,
                child: Container(
                  width: 124,
                  height: 92,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(color: const Color(0xFF6B55FF), width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isHappy ? 'YAY!' : 'PIP',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4E3AC9),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: isHappy ? 52 : 34,
                        height: isHappy ? 14 : 8,
                        decoration: BoxDecoration(
                          color: isHappy ? const Color(0xFFFFB74D) : const Color(0xFF84DCC6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 4,
                child: Container(
                  width: 6,
                  height: 26,
                  color: const Color(0xFF4E3AC9),
                ),
              ),
              Positioned(
                top: -6,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFC943),
                  ),
                ),
              ),
              if (isSpeaking)
                const Positioned(
                  right: -4,
                  top: 50,
                  child: _SoundWave(),
                ),
              if (isHappy)
                const Positioned(
                  left: -10,
                  top: 36,
                  child: Text('✨', style: TextStyle(fontSize: 28)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye({required this.isHappy});

  final bool isHappy;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isHappy ? 18 : 14,
      height: isHappy ? 8 : 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SoundWave extends StatelessWidget {
  const _SoundWave();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('🔊', style: TextStyle(fontSize: 28)),
        SizedBox(height: 2),
        Text('🎵', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
