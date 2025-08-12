import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _animationController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 8 : 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF6C63FF).withOpacity(0.2),
                          const Color(0xFF9C27B0).withOpacity(0.15),
                          const Color(0xFFFFD700).withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Animated background pattern
                        AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: Size(double.infinity, 180),
                              painter: BalancePatternPainter(_rotationAnimation.value),
                            );
                          },
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Balance',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: _isBalanceVisible
                                          ? ShaderMask(
                                              shaderCallback: (bounds) => const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFD700),
                                                  Color(0xFFFFFFFF),
                                                  Color(0xFF6C63FF),
                                                ],
                                              ).createShader(bounds),
                                              child: Text(
                                                '\$12,547.89',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: isSmallScreen ? 28 : 32,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '••••••••',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.6),
                                                fontSize: isSmallScreen ? 28 : 32,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                
                                // Visibility toggle
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isBalanceVisible = !_isBalanceVisible;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Icon(
                                      _isBalanceVisible 
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.white.withOpacity(0.8),
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Growth indicator
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF00E676).withOpacity(0.2),
                                border: Border.all(
                                  color: const Color(0xFF00E676).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: const Color(0xFF00E676),
                                    size: isSmallScreen ? 16 : 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+12.5% this month',
                                    style: TextStyle(
                                      color: const Color(0xFF00E676),
                                      fontSize: isSmallScreen ? 12 : 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Quick actions
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    Icons.add,
                                    'Deposit',
                                    const Color(0xFF00E676),
                                    isSmallScreen,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    Icons.remove,
                                    'Withdraw',
                                    const Color(0xFF6C63FF),
                                    isSmallScreen,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    Icons.swap_horiz,
                                    'Transfer',
                                    const Color(0xFFFFD700),
                                    isSmallScreen,
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 10 : 12,
        horizontal: isSmallScreen ? 8 : 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.1),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: isSmallScreen ? 20 : 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isSmallScreen ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class BalancePatternPainter extends CustomPainter {
  final double animation;

  BalancePatternPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw animated circles
    for (int i = 0; i < 3; i++) {
      final radius = 30.0 + (i * 25);
      final center = Offset(
        size.width * 0.8 + math.cos(animation + i) * 10,
        size.height * 0.3 + math.sin(animation + i) * 10,
      );
      canvas.drawCircle(center, radius, paint);
    }

    // Draw animated lines
    final linePaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.02)
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      final start = Offset(
        (size.width * 0.1) + (i * size.width * 0.2),
        size.height * 0.8 + math.sin(animation + i) * 5,
      );
      final end = Offset(
        start.dx + 40,
        start.dy + math.cos(animation + i) * 10,
      );
      canvas.drawLine(start, end, linePaint);
    }
  }

  @override
  bool shouldRepaint(BalancePatternPainter oldDelegate) => animation != oldDelegate.animation;
}
