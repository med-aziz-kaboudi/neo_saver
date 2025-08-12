import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../components/home/home_header.dart';
import '../components/home/balance_card.dart';
import '../components/home/quick_actions.dart';
import '../components/home/recent_transactions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _rotationAnimation;
  
  List<FloatingParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );
    
    _backgroundController.repeat();
    _initParticles();
  }

  void _initParticles() {
    final random = math.Random();
    particles = List.generate(6, (index) {
      return FloatingParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 1,
        speed: random.nextDouble() * 0.1 + 0.02,
        opacity: random.nextDouble() * 0.2 + 0.1,
        color: [
          const Color(0xFF6C63FF),
          const Color(0xFF9C27B0),
          const Color(0xFFFFD700),
          const Color(0xFF00E676),
        ][random.nextInt(4)],
      );
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
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
                  animation: _backgroundController,
                  builder: (context, child) {
                    final progress = _backgroundController.value;
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
                              color: const Color(0xFF6C63FF).withOpacity(0.08),
                              width: 2,
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
                              color: const Color(0xFFFFD700).withOpacity(0.05),
                              width: 2,
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
              child: Column(
                children: [
                  // Header
                  const HomeHeader(),
                  
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Balance card
                          const BalanceCard(),
                          
                          // Quick actions
                          const QuickActions(),
                          
                          // Recent transactions
                          const RecentTransactions(),
                          
                          // Extra space for bottom nav
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FloatingParticle class for background animation
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
