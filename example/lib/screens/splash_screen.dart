import 'package:flutter/widgets.dart';
import 'showcase_screen.dart';

/// Splash screen with "cu" branding in Cyrovoid font
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _letterSpacing;
  late Animation<double> _fadeOut;
  bool _showShowcase = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Fade in from 0-30%
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Letter spacing animation from 30-60%
    _letterSpacing = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Fade out from 80-100%
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      setState(() => _showShowcase = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showShowcase) {
      return const ShowcaseScreen();
    }

    return Container(
      color: const Color(0xFF000000),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeIn.value * _fadeOut.value,
              child: Text(
                'cu',
                style: TextStyle(
                  fontFamily: 'Cyrovoid',
                  fontSize: 72,
                  letterSpacing: _letterSpacing.value,
                  color: const Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
