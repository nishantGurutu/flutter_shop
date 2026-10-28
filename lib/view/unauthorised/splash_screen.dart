import 'package:shop/services/splash/splash_service.dart';
import 'package:flutter/material.dart';
import 'package:shop/utils/const_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final SplashService _splashService = SplashService();

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _typingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<int> _typingAnimation;

  final String _fullText = "बेहतरीन उत्पाद - सही सलाह - बेहतर फसल";
  String _displayedText = "";
  int _currentWordIndex = 0;
  List<String> _words = [];

  @override
  void initState() {
    super.initState();

    _words = _fullText.split(' ');

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _typingAnimation = IntTween(
      begin: 0,
      end: _words.length,
    ).animate(CurvedAnimation(parent: _typingController, curve: Curves.linear));

    _fadeController.forward();
    _scaleController.forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _typingController.forward();
    });

    _typingAnimation.addListener(() {
      if (_typingAnimation.isCompleted) return;

      final newWordIndex = _typingAnimation.value;
      if (newWordIndex != _currentWordIndex && newWordIndex <= _words.length) {
        setState(() {
          _currentWordIndex = newWordIndex;
          _displayedText = _words.take(_currentWordIndex).join(' ');
        });
      }
    });

    _splashService.isLogin(context);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(splashImage, height: 150),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _typingAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      _displayedText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2.0,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
