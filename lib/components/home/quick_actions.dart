import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _staggerController;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _staggerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Create staggered animations for each item
    _itemAnimations = List.generate(6, (index) {
      final start = (index * 0.1).clamp(0.0, 1.0);
      final end = (start + 0.3).clamp(0.0, 1.0);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.elasticOut),
        ),
      );
    });

    _animationController.forward();
    _staggerController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 8 : 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                  const Color(0xFF6C63FF).withOpacity(0.08),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                      ).createShader(bounds),
                      child: Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: _staggerController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _staggerController.value * 2 * math.pi,
                          child: Icon(
                            Icons.auto_awesome,
                            color: const Color(0xFFFFD700).withOpacity(0.8),
                            size: isSmallScreen ? 20 : 22,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                // Actions grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: isSmallScreen ? 12 : 16,
                  crossAxisSpacing: isSmallScreen ? 12 : 16,
                  childAspectRatio: 1.0,
                  children: [
                    _buildActionItem(0, Icons.account_balance_wallet, 'Send Money', const Color(0xFF6C63FF)),
                    _buildActionItem(1, Icons.receipt_long, 'Pay Bills', const Color(0xFF00E676)),
                    _buildActionItem(2, Icons.phone_android, 'Mobile Top Up', const Color(0xFFFF9800)),
                    _buildActionItem(3, Icons.trending_up, 'Invest', const Color(0xFF9C27B0)),
                    _buildActionItem(4, Icons.savings, 'Save Goals', const Color(0xFFFFD700)),
                    _buildActionItem(5, Icons.more_horiz, 'More', const Color(0xFF607D8B)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(int index, IconData icon, String label, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return AnimatedBuilder(
      animation: _itemAnimations[index],
      builder: (context, child) {
        final animationValue = _itemAnimations[index].value.clamp(0.0, 1.0);
        
        return Transform.scale(
          scale: animationValue,
          child: Transform.translate(
            offset: Offset(0, (1 - animationValue) * 20),
            child: Opacity(
              opacity: animationValue,
              child: GestureDetector(
                onTap: () {
                  // Handle action tap
                  _handleActionTap(label);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _staggerController,
                    builder: (context, child) {
                      final glowIntensity = (0.5 + math.sin(_staggerController.value * 2 * math.pi + index) * 0.2).clamp(0.0, 1.0);
                      
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity((0.1 * glowIntensity).clamp(0.0, 1.0)),
                              blurRadius: (10 * glowIntensity).clamp(0.0, 20.0),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: color.withOpacity(0.1),
                              ),
                              child: Icon(
                                icon,
                                color: color,
                                size: isSmallScreen ? 24 : 28,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 6 : 8),
                            Text(
                              label,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isSmallScreen ? 10 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleActionTap(String action) {
    // Show a snackbar or handle navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action tapped!'),
        backgroundColor: const Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
