import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late AnimationController _iconController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
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
    particles = List.generate(8, (index) {
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

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Simulate sending reset email
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      _showSuccessPopup();
    }
  }

  void _showSuccessPopup() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350 || screenSize.height < 600;
    final isTablet = screenSize.shortestSide >= 600;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Center(
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
                final clampedScale = (scaleValue * 0.8 + 0.2).clamp(0.1, 1.0);
                final clampedOpacity = opacityValue.clamp(0.0, 1.0);
                
                return Transform.scale(
                  scale: clampedScale,
                  child: Opacity(
                    opacity: clampedOpacity,
                    child: Container(
                      margin: EdgeInsets.all(isSmallScreen ? 20 : 40),
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 400 : (isSmallScreen ? 280 : 340),
                        maxHeight: screenSize.height * 0.7,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF6C63FF).withOpacity(0.3),
                                  const Color(0xFF00E676).withOpacity(0.25),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00E676).withOpacity(0.3),
                                  blurRadius: 25,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Success Icon
                                Container(
                                  width: isSmallScreen ? 70 : 80,
                                  height: isSmallScreen ? 70 : 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00E676), Color(0xFF4CAF50)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00E676).withOpacity(0.6),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: isSmallScreen ? 35 : 40,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 20),
                                
                                // Success Title
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [
                                      Color(0xFF00E676),
                                      Color(0xFFFFD700),
                                      Color(0xFF6C63FF),
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    'Email Sent!',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 22 : 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 8 : 12),
                                
                                // Success Message
                                Text(
                                  'We\'ve sent a password reset link to:\n${_emailController.text}\n\nCheck your inbox and follow the instructions to reset your password.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: isSmallScreen ? 20 : 24),
                                
                                // OK Button
                                SizedBox(
                                  width: double.infinity,
                                  height: isSmallScreen ? 44 : 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close popup
                                      Navigator.of(context).pop(); // Go back to login
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Back to Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isSmallScreen ? 14 : 16,
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
                    ),
                  ),
                );
              },
            );
          },
        ),
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
    _iconController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _emailController.dispose();
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

            // Back button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
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
                                    // Forgot password section
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 40),
                                      child: Column(
                                        children: [
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
                                                            Color.lerp(const Color(0xFF6C63FF), const Color(0xFFFFD700), _pulseAnimation.value - 1)!,
                                                            Color.lerp(const Color(0xFF9C27B0), const Color(0xFF00E676), _pulseAnimation.value - 1)!,
                                                          ],
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(0xFF6C63FF).withOpacity(0.4 * pulse),
                                                            blurRadius: 20 * pulse,
                                                            spreadRadius: 2 * pulse,
                                                          ),
                                                          BoxShadow(
                                                            color: const Color(0xFFFFD700).withOpacity(0.2 * pulse),
                                                            blurRadius: 40 * pulse,
                                                            spreadRadius: 5 * pulse,
                                                          ),
                                                        ],
                                                      ),
                                                      child: AnimatedBuilder(
                                                        animation: _rotationAnimation,
                                                        builder: (context, child) {
                                                          return Transform.rotate(
                                                            angle: _rotationAnimation.value * 0.5,
                                                            child: const Icon(
                                                              Icons.lock_reset,
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
                                          
                                          // Title
                                          ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                                            ).createShader(bounds),
                                            child: Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                fontSize: _getResponsiveSize(context, 32),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Enter your email address and we\'ll send you a link to reset your password.',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: _getResponsiveSize(context, 16),
                                              height: 1.4,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Reset form in glassmorphism card
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
                                              // Email field
                                              TextFormField(
                                                controller: _emailController,
                                                keyboardType: TextInputType.emailAddress,
                                                style: const TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  labelText: 'Email Address',
                                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                                  prefixIcon: AnimatedBuilder(
                                                    animation: _pulseAnimation,
                                                    builder: (context, child) {
                                                      return Transform.scale(
                                                        scale: _pulseAnimation.value * 0.3 + 0.7,
                                                        child: Icon(
                                                          Icons.email,
                                                          color: Color.lerp(
                                                            const Color(0xFFFFD700),
                                                            const Color(0xFF6C63FF),
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
                                                  if (value?.isEmpty ?? true) return 'Please enter your email';
                                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                                                    return 'Please enter a valid email';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 30),
                                              
                                              // Send Reset Link button
                                              SizedBox(
                                                width: double.infinity,
                                                height: 56,
                                                child: ElevatedButton(
                                                  onPressed: _isLoading ? null : _handleForgotPassword,
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
                                                              'Send Reset Link',
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

                                    // Back to login link
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Remember your password? ",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 16,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.of(context).pop(),
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
