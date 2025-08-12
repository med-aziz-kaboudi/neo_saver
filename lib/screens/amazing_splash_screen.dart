import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'login_screen.dart';
import '../services/auth_service.dart';
import '../main.dart';

class AmazingSplashScreen extends StatefulWidget {
  const AmazingSplashScreen({super.key});

  @override
  State<AmazingSplashScreen> createState() => _AmazingSplashScreenState();
}

class _AmazingSplashScreenState extends State<AmazingSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _pulseAnimation;

  O3DController o3dController = O3DController();
  List<FloatingParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initParticles();
    _startAnimationSequence();
    _startNavigationTimer();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initParticles() {
    final random = math.Random();
    particles = List.generate(14, (index) {
      return FloatingParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.25 + 0.08,
        opacity: (random.nextDouble() * 0.35 + 0.2).clamp(0.2, 0.55),
        color: [
          const Color(0xFF6C63FF),
          const Color(0xFF9C27B0),
          const Color(0xFFFFD700),
          const Color(0xFF00E676),
        ][random.nextInt(4)],
      );
    });
  }

  void _startAnimationSequence() {
    _fadeController.forward();
    _rotationController.repeat();
    _particleController.repeat();
    _pulseController.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _textController.forward();
    });
  }

  void _startNavigationTimer() {
    Timer(const Duration(seconds: 5), () async {
      if (!mounted) return;
      
      // Check if user is already logged in
      final isLoggedIn = await AuthService.isLoggedIn();
      
      if (isLoggedIn) {
        // User is logged in, go directly to MainScreen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              );
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.08),
                  end: Offset.zero,
                ).animate(curved),
                child: FadeTransition(opacity: curved, child: child),
              );
            },
            transitionDuration: const Duration(milliseconds: 900),
          ),
        );
      } else {
        // User is not logged in, go to LoginScreen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              );
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.08),
                  end: Offset.zero,
                ).animate(curved),
                child: FadeTransition(opacity: curved, child: child),
              );
            },
            transitionDuration: const Duration(milliseconds: 900),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double _getResponsiveSize(BuildContext context, double baseSize) {
    final size = MediaQuery.of(context).size;
    final shortestSide = math.min(size.width, size.height);
    final scaleFactor = (shortestSide / 400).clamp(0.75, 1.4);
    return baseSize * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final modelSize = _getResponsiveSize(context, isTablet ? 320 : 260);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.3,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A3A),
              Color(0xFF2D2D5F),
              Color(0xFF0A0A1A),
            ],
            stops: [0.0, 0.35, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            ...particles.map((particle) => AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    final progress = _particleController.value;
                    final y = (particle.y + progress * particle.speed) % 1.0;
                    return Positioned(
                      left: particle.x * size.width,
                      top: y * size.height,
                      child: Container(
                        width: particle.size,
                        height: particle.size,
                        decoration: BoxDecoration(
                          color: particle.color
                              .withOpacity(particle.opacity.clamp(0.0, 1.0)),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: particle.color.withOpacity(
                                  (particle.opacity * 0.35).clamp(0.0, 1.0)),
                              blurRadius: particle.size * 2,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),

            // Rotating rings—centered behind content
            Center(
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Container(
                          width: modelSize + 120,
                          height: modelSize + 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  const Color(0xFF6C63FF).withOpacity(0.18),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: -_rotationAnimation.value * 0.7,
                        child: Container(
                          width: modelSize + 40,
                          height: modelSize + 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  const Color(0xFFFFD700).withOpacity(0.14),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // MAIN centered content
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 3D model with pulse/scale
                        AnimatedBuilder(
                          animation: Listenable.merge(
                              [_scaleAnimation, _pulseAnimation]),
                          builder: (context, child) {
                            final scale = (_scaleAnimation.value *
                                    _pulseAnimation.value)
                                .clamp(0.1, 2.0);
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: modelSize,
                                height: modelSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C63FF)
                                          .withOpacity(0.35),
                                      blurRadius: 40,
                                      spreadRadius: 8,
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFFFD700)
                                          .withOpacity(0.25),
                                      blurRadius: 70,
                                      spreadRadius: 6,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: O3D.asset(
                                    src: 'assets/models/splash.glb',
                                    controller: o3dController,
                                    ar: false,
                                    autoRotate: true,
                                    autoPlay: true,
                                    cameraControls: false,
                                    backgroundColor: Colors.transparent,
                                    loading: Loading.eager,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: isTablet ? 28 : 22),

                        // Frosted glass card with title + subtitle + loader
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            final opacity =
                                _fadeAnimation.value.clamp(0.0, 1.0);
                            return Opacity(
                              opacity: opacity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 24 : 18,
                                      vertical: isTablet ? 22 : 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Title & subtitle
                                        AnimatedBuilder(
                                          animation: _textAnimation,
                                          builder: (context, child) {
                                            final t = _textAnimation.value;
                                            final offset = 30 * (1 - t);
                                            return Transform.translate(
                                              offset: Offset(0, offset),
                                              child: Column(
                                                children: [
                                                  ShaderMask(
                                                    shaderCallback: (bounds) =>
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(0xFFFFD700),
                                                        Color(0xFF6C63FF),
                                                        Color(0xFF9C27B0),
                                                      ],
                                                    ).createShader(bounds),
                                                    child: Text(
                                                      'NEO SAVER',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            _getResponsiveSize(
                                                                context,
                                                                isTablet
                                                                    ? 44
                                                                    : 36),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 4,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: isTablet
                                                          ? 10
                                                          : 8),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.savings,
                                                          color:
                                                              Color(0xFFFFD700),
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          'Smart Financial Freedom',
                                                          style: TextStyle(
                                                            fontSize:
                                                                _getResponsiveSize(
                                                                    context,
                                                                    isTablet
                                                                        ? 18
                                                                        : 16),
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.92),
                                                            letterSpacing: 1.2,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        const Icon(
                                                          Icons.trending_up,
                                                          color:
                                                              Color(0xFF00E676),
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: isTablet
                                                          ? 8
                                                          : 6),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'SAVE • INVEST • GROW • PROSPER',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            _getResponsiveSize(
                                                                context,
                                                                isTablet
                                                                    ? 13
                                                                    : 12),
                                                        color: const Color(
                                                                0xFFFFD700)
                                                            .withOpacity(0.85),
                                                        letterSpacing: 2,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        SizedBox(
                                            height: isTablet ? 18 : 14),

                                        // Loader
                                        Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  width: _getResponsiveSize(
                                                      context,
                                                      isTablet ? 64 : 56),
                                                  height: _getResponsiveSize(
                                                      context,
                                                      isTablet ? 64 : 56),
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 3.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                          const Color(
                                                                  0xFF6C63FF)
                                                              .withOpacity(
                                                                  0.3),
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: _getResponsiveSize(
                                                      context,
                                                      isTablet ? 64 : 56),
                                                  height: _getResponsiveSize(
                                                      context,
                                                      isTablet ? 64 : 56),
                                                  child:
                                                      const CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                          Color(0xFFFFD700),
                                                        ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.attach_money,
                                                  color: Colors.white,
                                                  size: _getResponsiveSize(
                                                      context,
                                                      isTablet ? 26 : 22),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height:
                                                    isTablet ? 14 : 10),
                                            Text(
                                              'Preparing Your Financial Journey...',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.85),
                                                fontSize:
                                                    _getResponsiveSize(
                                                        context,
                                                        isTablet
                                                            ? 16
                                                            : 14),
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              'Every penny counts 💰',
                                              style: TextStyle(
                                                color: const Color(
                                                        0xFFFFD700)
                                                    .withOpacity(0.95),
                                                fontSize:
                                                    _getResponsiveSize(
                                                        context,
                                                        isTablet
                                                            ? 13
                                                            : 12),
                                                fontStyle:
                                                    FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Fewer floating icons, gently framing sides, not overlapping center
            ...List.generate(4, (index) {
              return AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  final progress =
                      (_particleController.value + index * 0.25) % 1.0;
                  final sidePadding = 24.0;
                  final x = index.isEven
                      ? sidePadding
                      : size.width - sidePadding - 24;
                  final y = size.height * progress;
                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: 0.75,
                      child: Transform.rotate(
                        angle: progress * 2 * math.pi,
                        child: Icon(
                          [
                            Icons.attach_money,
                            Icons.savings,
                            Icons.trending_up,
                            Icons.account_balance_wallet,
                          ][index % 4],
                          color: const Color(0xFFFFD700).withOpacity(0.66),
                          size: _getResponsiveSize(
                              context, 18 + (index % 3) * 4),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class FloatingParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final Color color;

  FloatingParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}