import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _chartAnimationController;
  late List<Animation<double>> _cardAnimations;
  int _selectedPeriod = 0; // 0: Week, 1: Month, 2: Year

  final List<String> _periods = ['Week', 'Month', 'Year'];
  
  final List<ExpenseCategory> _expenseCategories = [
    ExpenseCategory(
      name: 'Shopping',
      amount: 1245.67,
      percentage: 35.2,
      color: const Color(0xFF6C63FF),
      icon: Icons.shopping_bag,
    ),
    ExpenseCategory(
      name: 'Food & Dining',
      amount: 892.34,
      percentage: 25.3,
      color: const Color(0xFF00E676),
      icon: Icons.restaurant,
    ),
    ExpenseCategory(
      name: 'Transportation',
      amount: 567.89,
      percentage: 16.1,
      color: const Color(0xFFFFD700),
      icon: Icons.directions_car,
    ),
    ExpenseCategory(
      name: 'Entertainment',
      amount: 423.12,
      percentage: 12.0,
      color: const Color(0xFFFF5722),
      icon: Icons.movie,
    ),
    ExpenseCategory(
      name: 'Health',
      amount: 234.56,
      percentage: 6.6,
      color: const Color(0xFF9C27B0),
      icon: Icons.local_hospital,
    ),
    ExpenseCategory(
      name: 'Others',
      amount: 167.42,
      percentage: 4.8,
      color: const Color(0xFF607D8B),
      icon: Icons.more_horiz,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardAnimations = List.generate(6, (index) {
      final start = (index * 0.1).clamp(0.0, 1.0);
      final end = (start + 0.3).clamp(0.0, 1.0);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _animationController.forward();
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header
                _buildHeader(isSmallScreen),
                
                // Period Selector
                _buildPeriodSelector(isSmallScreen),
                
                // Stats Summary
                _buildStatsSummary(isSmallScreen),
                
                // Spending Chart
                _buildSpendingChart(isSmallScreen),
                
                // Category Breakdown
                _buildCategoryBreakdown(isSmallScreen),
                
                // Monthly Comparison
                _buildMonthlyComparison(isSmallScreen),
                
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
            ).createShader(bounds),
            child: Text(
              'Statistics',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 24 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Icon(
              Icons.file_download,
              color: Colors.white.withOpacity(0.8),
              size: isSmallScreen ? 20 : 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      child: Row(
        children: _periods.asMap().entries.map((entry) {
          final index = entry.key;
          final period = entry.value;
          final isSelected = index == _selectedPeriod;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 6),
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isSelected
                      ? const Color(0xFF6C63FF).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6C63FF)
                        : Colors.white.withOpacity(0.1),
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ] : null,
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF6C63FF) : Colors.white.withOpacity(0.8),
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsSummary(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Spent',
              '\$3,530.00',
              Icons.trending_down,
              const Color(0xFFFF5252),
              0,
              isSmallScreen,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: _buildSummaryCard(
              'Avg/Day',
              '\$126.07',
              Icons.calendar_today,
              const Color(0xFF6C63FF),
              1,
              isSmallScreen,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: _buildSummaryCard(
              'Budget Left',
              '\$1,470.00',
              Icons.trending_up,
              const Color(0xFF00E676),
              2,
              isSmallScreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, int index, bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _cardAnimations[index],
      builder: (context, child) {
        final animationValue = _cardAnimations[index].value.clamp(0.0, 1.0);
        
        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Opacity(
            opacity: animationValue,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: isSmallScreen ? 20 : 24,
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildSpendingChart(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            height: isSmallScreen ? 220 : 260,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spending Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _chartAnimationController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: PieChartPainter(_expenseCategories, _chartAnimationController.value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Breakdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _expenseCategories.length,
                  separatorBuilder: (context, index) => SizedBox(height: isSmallScreen ? 8 : 12),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _cardAnimations[index],
                      builder: (context, child) {
                        final animationValue = _cardAnimations[index].value.clamp(0.0, 1.0);
                        
                        return Transform.translate(
                          offset: Offset((1 - animationValue) * 100, 0),
                          child: Opacity(
                            opacity: animationValue,
                            child: _buildCategoryItem(_expenseCategories[index], isSmallScreen),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(ExpenseCategory category, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 40 : 45,
            height: isSmallScreen ? 40 : 45,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: isSmallScreen ? 4 : 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: category.percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: category.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${category.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${category.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyComparison(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Comparison',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildComparisonItem('This Month', '\$3,530', const Color(0xFF6C63FF), isSmallScreen),
                    _buildComparisonItem('Last Month', '\$2,890', const Color(0xFF00E676), isSmallScreen),
                    _buildComparisonItem('Difference', '+\$640', const Color(0xFFFFD700), isSmallScreen),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonItem(String title, String value, Color color, bool isSmallScreen) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: isSmallScreen ? 12 : 14,
          ),
        ),
      ],
    );
  }
}

class ExpenseCategory {
  final String name;
  final double amount;
  final double percentage;
  final Color color;
  final IconData icon;

  ExpenseCategory({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

class PieChartPainter extends CustomPainter {
  final List<ExpenseCategory> categories;
  final double animation;

  PieChartPainter(this.categories, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;
    
    double startAngle = -math.pi / 2;
    
    for (final category in categories) {
      final sweepAngle = (category.percentage / 100) * 2 * math.pi * animation.clamp(0.0, 1.0);
      
      final paint = Paint()
        ..color = category.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = const Color(0xFF0F0F23)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, centerPaint);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => animation != oldDelegate.animation;
}
