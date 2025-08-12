import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;
import 'login_screen.dart';

enum PasswordStrength { weak, medium, strong }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  PasswordStrength _passwordStrength = PasswordStrength.weak;
  
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late AnimationController _strengthController;
  late AnimationController _iconController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _strengthAnimation;
  late Animation<double> _iconBounceAnimation;
  late Animation<double> _iconRotateAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  
  List<FloatingParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initParticles();
    _animationController.forward();
    _backgroundController.repeat();
    _particleController.repeat();
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
    
    // Start icon animation after a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _iconController.forward();
    });
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );
    
    _strengthController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );
    
    _strengthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _strengthController, curve: Curves.easeInOut),
    );
    
    _iconBounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
    
    _iconRotateAnimation = Tween<double>(begin: 0.0, end: 0.5 * math.pi).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );
  }

  void _initParticles() {
    final random = math.Random();
    particles = List.generate(10, (index) {
      return FloatingParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 1,
        speed: random.nextDouble() * 0.2 + 0.05,
        opacity: random.nextDouble() * 0.3 + 0.1,
        color: [
          const Color(0xFF6C63FF),
          const Color(0xFF9C27B0),
          const Color(0xFFFFD700),
          const Color(0xFF00E676),
        ][random.nextInt(4)],
      );
    });
  }

  PasswordStrength _checkPasswordStrength(String password) {
    if (password.length < 8) return PasswordStrength.weak;
    
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    if (!hasUpper || !hasLower || !hasNumber) {
      return PasswordStrength.weak;
    }
    
    if (hasSpecial) {
      return PasswordStrength.strong;
    }
    
    return PasswordStrength.medium;
  }

  void _onPasswordChanged(String password) {
    PasswordStrength newStrength = _checkPasswordStrength(password);
    if (newStrength != _passwordStrength) {
      setState(() => _passwordStrength = newStrength);
      _strengthController.forward();
      Timer(const Duration(milliseconds: 100), () {
        if (mounted) _strengthController.reverse();
      });
    }
  }

  String _getPasswordStrengthText() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return 'Weak (Not Accepted)';
      case PasswordStrength.medium:
        return 'Medium (Accepted)';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  Color _getPasswordStrengthColor() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  double _getPasswordStrengthProgress() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
    }
  }


  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_passwordStrength == PasswordStrength.weak) {
      _showErrorDialog('Weak Password', 'Please create a stronger password with at least 8 characters, uppercase, lowercase, and a number.');
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Simulate signup process
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    // Show success popup and auto-redirect
    _showSuccessAndRedirect();
  }

  void _showSuccessAndRedirect() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350 || screenSize.height < 600;
    final isTablet = screenSize.shortestSide >= 600;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, scaleValue, child) {
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutBack,
                builder: (context, opacityValue, child) {
                  // Clamp values to ensure they're within valid ranges
                  final clampedScale = (scaleValue * 0.8 + 0.2).clamp(0.1, 1.0);
                  final clampedOpacity = opacityValue.clamp(0.0, 1.0);
                  
                  return Transform.scale(
                    scale: clampedScale,
                    child: Opacity(
                      opacity: clampedOpacity,
                      child: Container(
                        margin: EdgeInsets.all(isSmallScreen ? 20 : 40),
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 500 : (isSmallScreen ? 300 : 380),
                          maxHeight: screenSize.height * 0.8,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: EdgeInsets.all(isSmallScreen ? 24 : 40),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF6C63FF).withOpacity(0.3),
                                    const Color(0xFF00E676).withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E676).withOpacity(0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF6C63FF).withOpacity(0.2),
                                    blurRadius: 40,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated Success Icon
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 1200),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.bounceOut,
                                    builder: (context, bounceValue, child) {
                                      final clampedBounce = bounceValue.clamp(0.0, 1.0);
                                      final iconSize = isSmallScreen ? 70.0 : (isTablet ? 120.0 : 100.0);
                                      
                                      return Transform.scale(
                                        scale: clampedBounce,
                                        child: Container(
                                          width: iconSize,
                                          height: iconSize,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF00E676),
                                                Color(0xFF4CAF50),
                                                Color(0xFF00C853),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF00E676).withOpacity(0.6),
                                                blurRadius: 25,
                                                spreadRadius: 3,
                                              ),
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.3),
                                                blurRadius: 10,
                                                spreadRadius: -5,
                                                offset: const Offset(-3, -3),
                                              ),
                                            ],
                                          ),
                                          child: TweenAnimationBuilder<double>(
                                            duration: const Duration(milliseconds: 800),
                                            tween: Tween(begin: 0.0, end: 1.0),
                                            curve: Curves.easeInOut,
                                            builder: (context, iconValue, child) {
                                              final clampedIconValue = iconValue.clamp(0.0, 1.0);
                                              return Transform.rotate(
                                                angle: clampedIconValue * math.pi * 0.1,
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                  size: iconSize * 0.5,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withOpacity(0.3),
                                                      offset: const Offset(2, 2),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: isSmallScreen ? 16 : 24),
                                  
                                  // Animated Title
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 1000),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutBack,
                                    builder: (context, titleValue, child) {
                                      final clampedTitleValue = titleValue.clamp(0.0, 1.0);
                                      return Transform.translate(
                                        offset: Offset(0, (1 - clampedTitleValue) * 30),
                                        child: Opacity(
                                          opacity: clampedTitleValue,
                                          child: ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [
                                                Color(0xFF00E676),
                                                Color(0xFFFFD700),
                                                Color(0xFF6C63FF),
                                              ],
                                              stops: [0.0, 0.5, 1.0],
                                            ).createShader(bounds),
                                            child: Text(
                                              '🎉 SUCCESS! 🎉',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 24 : (isTablet ? 36 : 32),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: isSmallScreen ? 8 : 12),
                                  
                                  // Animated Subtitle
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 1200),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, subtitleValue, child) {
                                      final clampedSubtitleValue = subtitleValue.clamp(0.0, 1.0);
                                      return Transform.translate(
                                        offset: Offset(0, (1 - clampedSubtitleValue) * 20),
                                        child: Opacity(
                                          opacity: clampedSubtitleValue,
                                          child: Text(
                                            'Your NEO SAVER account has been\ncreated successfully!',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isSmallScreen ? 14 : (isTablet ? 20 : 18),
                                              height: 1.4,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: isSmallScreen ? 16 : 20),
                                  
                                  // Animated Progress Indicator
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 2500),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeInOut,
                                    builder: (context, progressValue, child) {
                                      final clampedProgress = progressValue.clamp(0.0, 1.0);
                                      return Column(
                                        children: [
                                          Text(
                                            'Redirecting to login...',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: isSmallScreen ? 12 : 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(height: isSmallScreen ? 8 : 12),
                                          Container(
                                            width: isSmallScreen ? 150 : 200,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(2),
                                              color: Colors.white.withOpacity(0.2),
                                            ),
                                            child: FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor: clampedProgress,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(2),
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xFF00E676),
                                                      Color(0xFFFFD700),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    // Auto-redirect after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop(); // Close popup
        
        // Small delay before navigation
        Timer(const Duration(milliseconds: 100), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 600),
              ),
            );
          }
        });
      }
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }

  double _getResponsiveSize(BuildContext context, double baseSize) {
    final size = MediaQuery.of(context).size;
    final shortestSide = math.min(size.width, size.height);
    final scaleFactor = (shortestSide / 400).clamp(0.75, 1.4);
    return baseSize * scaleFactor;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _strengthController.dispose();
    _iconController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A3A),
              Color(0xFF2D2D5F),
              Color(0xFF0A0A1A),
            ],
            stops: [0.0, 0.4, 0.8, 1.0],
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
                          color: particle.color.withOpacity(particle.opacity.clamp(0.0, 1.0)),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: particle.color.withOpacity((particle.opacity * 0.3).clamp(0.0, 1.0)),
                              blurRadius: particle.size * 2,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),

            // Animated background waves
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: size,
                  painter: WavePainter(_waveAnimation.value),
                );
              },
            ),

            // Rotating background rings with pulse effect
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
                builder: (context, child) {
                  final pulseScale = _pulseAnimation.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: pulseScale,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF6C63FF).withOpacity(0.15),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.1 - (pulseScale - 1),
                        child: Transform.rotate(
                          angle: -_rotationAnimation.value * 0.7,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFD700).withOpacity(0.12),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.08),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Additional inner ring
                      Transform.rotate(
                        angle: _rotationAnimation.value * 1.5,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF9C27B0).withOpacity(0.1),
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

            // Main content
            SafeArea(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Header section
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Column(
                                        children: [
                                          // Back button
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: IconButton(
                                              onPressed: () => Navigator.pop(context),
                                              icon: const Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          
                                          // Logo/Icon with animations
                                          AnimatedBuilder(
                                            animation: Listenable.merge([_iconBounceAnimation, _iconRotateAnimation, _pulseAnimation]),
                                            builder: (context, child) {
                                              final bounce = math.sin(_iconBounceAnimation.value * math.pi * 2) * 0.1;
                                              final pulse = 0.9 + (_pulseAnimation.value - 1).abs() * 0.2;
                                              return Transform.translate(
                                                offset: Offset(0, bounce * 20),
                                                child: Transform.scale(
                                                  scale: pulse,
                                                  child: Transform.rotate(
                                                    angle: _iconRotateAnimation.value,
                                                    child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color.lerp(const Color(0xFF6C63FF), const Color(0xFF00E676), _pulseAnimation.value - 1)!,
                                                            Color.lerp(const Color(0xFF9C27B0), const Color(0xFFFFD700), _pulseAnimation.value - 1)!,
                                                          ],
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(0xFF6C63FF).withOpacity(0.4 * pulse),
                                                            blurRadius: 20 * pulse,
                                                            spreadRadius: 2 * pulse,
                                                          ),
                                                          BoxShadow(
                                                            color: const Color(0xFF00E676).withOpacity(0.2 * pulse),
                                                            blurRadius: 40 * pulse,
                                                            spreadRadius: 5 * pulse,
                                                          ),
                                                        ],
                                                      ),
                                                      child: AnimatedBuilder(
                                                        animation: _rotationAnimation,
                                                        builder: (context, child) {
                                                          return Transform.rotate(
                                                            angle: _rotationAnimation.value * 0.3,
                                                            child: const Icon(
                                                              Icons.person_add,
                                                              color: Colors.white,
                                                              size: 40,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          
                                          // Create account text
                                          ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                                            ).createShader(bounds),
                                            child: Text(
                                              'Create Account',
                                              style: TextStyle(
                                                fontSize: _getResponsiveSize(context, 30),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Join NEO SAVER and start your financial journey',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: _getResponsiveSize(context, 16),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Signup form in glassmorphism card
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              // Username field
                                              TextFormField(
                                                controller: _usernameController,
                                                style: const TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  labelText: 'Username',
                                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                                  prefixIcon: AnimatedBuilder(
                                                    animation: _pulseAnimation,
                                                    builder: (context, child) {
                                                      return Transform.scale(
                                                        scale: _pulseAnimation.value * 0.3 + 0.7,
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Color.lerp(
                                                            const Color(0xFFFFD700),
                                                            const Color(0xFF00E676),
                                                            (_pulseAnimation.value - 0.8) / 0.4,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white.withOpacity(0.05),
                                                ),
                                                validator: (value) {
                                                  if (value?.isEmpty ?? true) return 'Please enter username';
                                                  if (value!.length < 3) return 'Username must be at least 3 characters';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              
                                              // Email field
                                              TextFormField(
                                                controller: _emailController,
                                                keyboardType: TextInputType.emailAddress,
                                                style: const TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  labelText: 'Email',
                                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                                  prefixIcon: AnimatedBuilder(
                                                    animation: _iconRotateAnimation,
                                                    builder: (context, child) {
                                                      return Transform.rotate(
                                                        angle: _iconRotateAnimation.value * 0.3,
                                                        child: Icon(
                                                          Icons.email,
                                                          color: Color.lerp(
                                                            const Color(0xFFFFD700),
                                                            const Color(0xFF6C63FF),
                                                            _iconRotateAnimation.value / (0.5 * math.pi),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white.withOpacity(0.05),
                                                ),
                                                validator: (value) {
                                                  if (value?.isEmpty ?? true) return 'Please enter email';
                                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                                                    return 'Please enter valid email';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              
                                              // Password field
                                              TextFormField(
                                                controller: _passwordController,
                                                obscureText: _obscurePassword,
                                                onChanged: _onPasswordChanged,
                                                style: const TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                                  prefixIcon: AnimatedBuilder(
                                                    animation: _strengthAnimation,
                                                    builder: (context, child) {
                                                      Color iconColor = const Color(0xFFFFD700);
                                                      if (_passwordStrength == PasswordStrength.medium) {
                                                        iconColor = const Color(0xFFFFA726);
                                                      } else if (_passwordStrength == PasswordStrength.strong) {
                                                        iconColor = const Color(0xFF00E676);
                                                      }
                                                      
                                                      return Transform.scale(
                                                        scale: 1.0 + _strengthAnimation.value * 0.2,
                                                        child: Icon(
                                                          Icons.lock,
                                                          color: iconColor,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                                      color: Colors.white.withOpacity(0.7),
                                                    ),
                                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(16),
                                                    borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white.withOpacity(0.05),
                                                ),
                                                validator: (value) {
                                                  if (value?.isEmpty ?? true) return 'Please enter password';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              
                                              // Password strength indicator
                                              if (_passwordController.text.isNotEmpty) ...[
                                                AnimatedBuilder(
                                                  animation: _strengthAnimation,
                                                  builder: (context, child) {
                                                    return Transform.scale(
                                                      scale: 1.0 + (_strengthAnimation.value * 0.05),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Password Strength: ',
                                                                style: TextStyle(
                                                                  color: Colors.white.withOpacity(0.8),
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              Text(
                                                                _getPasswordStrengthText(),
                                                                style: TextStyle(
                                                                  color: _getPasswordStrengthColor(),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 8),
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(4),
                                                            child: LinearProgressIndicator(
                                                              value: _getPasswordStrengthProgress(),
                                                              backgroundColor: Colors.white.withOpacity(0.2),
                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                _getPasswordStrengthColor(),
                                                              ),
                                                              minHeight: 6,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Text(
                                                            'Requirements: 8+ chars, uppercase, lowercase, number',
                                                            style: TextStyle(
                                                              color: Colors.white.withOpacity(0.6),
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                              
                                              const SizedBox(height: 30),
                                              
                                              // Sign up button
                                              SizedBox(
                                                width: double.infinity,
                                                height: 56,
                                                child: ElevatedButton(
                                                  onPressed: _isLoading ? null : _handleSignup,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.transparent,
                                                    foregroundColor: Colors.white,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                  ).copyWith(
                                                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                  ),
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)],
                                                      ),
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: _isLoading
                                                          ? const SizedBox(
                                                              width: 24,
                                                              height: 24,
                                                              child: CircularProgressIndicator(
                                                                color: Colors.white,
                                                                strokeWidth: 2,
                                                              ),
                                                            )
                                                          : const Text(
                                                              'Create Account',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    // Already have account link
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Already have an account? ",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 16,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                                            ).createShader(bounds),
                                            child: const Text(
                                              'Sign In',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = const Color(0xFF9C27B0).withOpacity(0.04)
      ..style = PaintingStyle.fill;

    // Wave 1
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.3 + 
                 math.sin((x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * 20 +
                 math.sin((x / size.width * 4 * math.pi) + (animationValue * 3 * math.pi)) * 10;
      path1.lineTo(x, y);
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Wave 2
    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.7 + 
                 math.sin((x / size.width * 3 * math.pi) + (animationValue * -2 * math.pi)) * 15 +
                 math.sin((x / size.width * 6 * math.pi) + (animationValue * 4 * math.pi)) * 8;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);

    // Wave 3
    final path3 = Path();
    path3.moveTo(0, size.height * 0.5);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.5 + 
                 math.sin((x / size.width * 1.5 * math.pi) + (animationValue * 1.5 * math.pi)) * 25 +
                 math.sin((x / size.width * 3 * math.pi) + (animationValue * -2.5 * math.pi)) * 12;
      path3.lineTo(x, y);
    }
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is WavePainter && oldDelegate.animationValue != animationValue;
  }
}
