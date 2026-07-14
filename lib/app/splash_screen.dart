import 'package:flutter/material.dart';

/// Animated Flutter hand-off from Android's static system splash screen.
class ZigiSplashScreen extends StatefulWidget {
  const ZigiSplashScreen({super.key});

  @override
  State<ZigiSplashScreen> createState() => _ZigiSplashScreenState();
}

class _ZigiSplashScreenState extends State<ZigiSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, .08),
          radius: 1.12,
          colors: [Color(0xfffdfffa), Color(0xffeffbdc), Color(0xffb8e980)],
          stops: [0, .58, 1],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
          builder: (context, child) {
            final value = _controller.value;
            return Transform.translate(
              offset: Offset(0, 5 - value * 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: .94 + value * .06,
                    child: Container(
                      width: 152,
                      height: 152,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(48),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xff348c39,
                            ).withValues(alpha: .22 + value * .09),
                            blurRadius: 28 + value * 10,
                            spreadRadius: value * 3,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/branding/zigiquest_app_icon.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'ZigiQuest',
                    style: TextStyle(
                      color: Color(0xff126b35),
                      fontSize: 45,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2.3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: 124,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: const LinearProgressIndicator(
                        minHeight: 4,
                        color: Color(0xff3d9d40),
                        backgroundColor: Color(0x223d9d40),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
