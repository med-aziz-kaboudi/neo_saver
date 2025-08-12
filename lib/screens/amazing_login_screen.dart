import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;
import 'signup_screen.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  List<FloatingParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initParticles();
    _animationController.forward();
    _backgroundController.repeat();
    _particleController.repeat();
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



  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Simulate login process
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      // For demo purposes, check if email/password match expected values
      if (_emailController.text.toLowerCase() == 'demo@neosaver.com' && 
          _passwordController.text == 'Demo123!') {
        // Show success popup and redirect
        _showSuccessAndRedirect();
      } else {
        // Show error popup
        _showLoginErrorPopup();
      }
    }
  }

  void _showLoginErrorPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            final screenSize = MediaQuery.of(context).size;
            final isSmallScreen = screenSize.width < 350;
            
            return Transform.scale(
              scale: value.clamp(0.1, 1.0),
              child: Container(
                margin: EdgeInsets.all(isSmallScreen ? 20 : 32),
                constraints: BoxConstraints(
                  maxWidth: isSmallScreen ? 280 : 340,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFF5252).withOpacity(0.2),
                            const Color(0xFFD32F2F).withOpacity(0.15),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFFF5252).withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5252).withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Error Icon
                          Container(
                            width: isSmallScreen ? 60 : 70,
                            height: isSmallScreen ? 60 : 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5252).withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: isSmallScreen ? 30 : 35,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          
                          // Error Title
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFFF5252), Color(0xFFFFD700)],
                            ).createShader(bounds),
                            child: Text(
                              'Login Failed',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          
                          // Error Message
                          Text(
                            'Wrong email or password.\nPlease check your credentials and try again.',
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
                              onPressed: () => Navigator.of(context).pop(),
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
                                    'Try Again',
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
            );
          },
        ),
      ),
    );
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
                                  BoxShadow(
                                    color: const Color(0xFF6C63FF).withOpacity(0.2),
                                    blurRadius: 35,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Success Icon
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 1000),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.bounceOut,
                                    builder: (context, bounceValue, child) {
                                      final iconSize = isSmallScreen ? 70.0 : (isTablet ? 100.0 : 80.0);
                                      
                                      return Transform.scale(
                                        scale: bounceValue.clamp(0.0, 1.0),
                                        child: Container(
                                          width: iconSize,
                                          height: iconSize,
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
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: iconSize * 0.6,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: isSmallScreen ? 16 : 20),
                                  
                                  // Success Title
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 800),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutBack,
                                    builder: (context, titleValue, child) {
                                      return Transform.translate(
                                        offset: Offset(0, (1 - titleValue.clamp(0.0, 1.0)) * 20),
                                        child: Opacity(
                                          opacity: titleValue.clamp(0.0, 1.0),
                                          child: ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [
                                                Color(0xFF00E676),
                                                Color(0xFFFFD700),
                                                Color(0xFF6C63FF),
                                              ],
                                            ).createShader(bounds),
                                            child: Text(
                                              '🎉 Welcome! 🎉',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 22 : (isTablet ? 30 : 26),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1.2,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: isSmallScreen ? 8 : 12),
                                  
                                  // Success Message
                                  TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 1000),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, subtitleValue, child) {
                                      return Transform.translate(
                                        offset: Offset(0, (1 - subtitleValue.clamp(0.0, 1.0)) * 15),
                                        child: Opacity(
                                          opacity: subtitleValue.clamp(0.0, 1.0),
                                          child: Text(
                                            'Successfully logged in!\nRedirecting to your dashboard...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isSmallScreen ? 14 : 16,
                                              height: 1.4,
                                            ),
                                            textAlign: TextAlign.center,
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    // Auto-redirect after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop(); // Close popup
        
        // Small delay before navigation
        Timer(const Duration(milliseconds: 100), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 800),
              ),
            );
          }
        });
      }
    });
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

            // Rotating background rings
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
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6C63FF).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: -_rotationAnimation.value * 0.7,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFFD700).withOpacity(0.08),
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
                                    // Welcome back section
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 40),
                                      child: Column(
                                        children: [
                                          // Logo/Icon
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF6C63FF).withOpacity(0.4),
                                                  blurRadius: 20,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          
                                          // Welcome text
                                          ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                                            ).createShader(bounds),
                                            child: Text(
                                              'Welcome Back!',
                                              style: TextStyle(
                                                fontSize: _getResponsiveSize(context, 32),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Sign in to your NEO SAVER account',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: _getResponsiveSize(context, 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Login form in glassmorphism card
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
                                                  labelText: 'Email',
                                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                                  prefixIcon: const Icon(Icons.email, color: Color(0xFFFFD700)),
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
                                                style: const TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                                  prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFD700)),
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
                                              const SizedBox(height: 20),
                                              
                                              // Forgot password link (moved above Sign In button)
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                                            const ForgotPasswordScreen(),
                                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                          return SlideTransition(
                                                            position: Tween<Offset>(
                                                              begin: const Offset(0.0, 1.0),
                                                              end: Offset.zero,
                                                            ).animate(CurvedAnimation(
                                                              parent: animation,
                                                              curve: Curves.easeInOutCubic,
                                                            )),
                                                            child: child,
                                                          );
                                                        },
                                                        transitionDuration: const Duration(milliseconds: 600),
                                                      ),
                                                    );
                                                  },
                                                  child: ShaderMask(
                                                    shaderCallback: (bounds) => const LinearGradient(
                                                      colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                                                    ).createShader(bounds),
                                                    child: const Text(
                                                      'Forgot Password?',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              
                                              // Login button
                                              SizedBox(
                                                width: double.infinity,
                                                height: 56,
                                                child: ElevatedButton(
                                                  onPressed: _isLoading ? null : _handleLogin,
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
                                                              'Sign In',
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

                                    // Sign up link
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account? ",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 16,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) =>
                                                    const SignupScreen(),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: const Offset(1.0, 0.0),
                                                      end: Offset.zero,
                                                    ).animate(CurvedAnimation(
                                                      parent: animation,
                                                      curve: Curves.easeInOutCubic,
                                                    )),
                                                    child: child,
                                                  );
                                                },
                                                transitionDuration: const Duration(milliseconds: 600),
                                              ),
                                            );
                                          },
                                          child: ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                                            ).createShader(bounds),
                                            child: const Text(
                                              'Sign Up',
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
