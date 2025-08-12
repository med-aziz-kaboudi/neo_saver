import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class InvestScreen extends StatefulWidget {
  const InvestScreen({super.key});

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _chartController;
  late List<Animation<double>> _itemAnimations;

  final List<Investment> _investments = [
    Investment(
      name: 'Apple Inc.',
      symbol: 'AAPL',
      price: 175.23,
      change: 2.34,
      changePercent: 1.35,
      color: const Color(0xFF007AFF),
    ),
    Investment(
      name: 'Tesla Inc.',
      symbol: 'TSLA',
      price: 248.50,
      change: -5.67,
      changePercent: -2.23,
      color: const Color(0xFFE31937),
    ),
    Investment(
      name: 'Microsoft Corp.',
      symbol: 'MSFT',
      price: 384.30,
      change: 7.89,
      changePercent: 2.10,
      color: const Color(0xFF00BCF2),
    ),
    Investment(
      name: 'NVIDIA Corp.',
      symbol: 'NVDA',
      price: 465.28,
      change: 12.45,
      changePercent: 2.75,
      color: const Color(0xFF76B900),
    ),
    Investment(
      name: 'Amazon.com Inc.',
      symbol: 'AMZN',
      price: 142.81,
      change: -1.23,
      changePercent: -0.85,
      color: const Color(0xFFFF9900),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _chartController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _itemAnimations = List.generate(_investments.length, (index) {
      final start = (index * 0.1).clamp(0.0, 1.0);
      final end = (start + 0.4).clamp(0.0, 1.0);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    _animationController.forward();
    _chartController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chartController.dispose();
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
                
                // Portfolio Overview
                _buildPortfolioOverview(isSmallScreen),
                
                // Performance Chart
                _buildPerformanceChart(isSmallScreen),
                
                // Investment Options
                _buildInvestmentOptions(isSmallScreen),
                
                // Watchlist
                _buildWatchlist(isSmallScreen),
                
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
              'Invest',
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
              Icons.search,
              color: Colors.white.withOpacity(0.8),
              size: isSmallScreen ? 20 : 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioOverview(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.2),
                  const Color(0xFF00E676).withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
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
                Text(
                  'Portfolio Value',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFFFFF), Color(0xFF00E676)],
                  ).createShader(bounds),
                  child: Text(
                    '\$24,567.89',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 28 : 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                        '+\$1,234.56 (+5.25%) Today',
                        style: TextStyle(
                          color: const Color(0xFF00E676),
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceChart(bool isSmallScreen) {
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
            height: isSmallScreen ? 200 : 240,
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
                  'Performance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _chartController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: ChartPainter(_chartController.value),
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

  Widget _buildInvestmentOptions(bool isSmallScreen) {
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
                  'Investment Options',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildOptionCard('Stocks', Icons.trending_up, const Color(0xFF6C63FF), isSmallScreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOptionCard('ETFs', Icons.pie_chart, const Color(0xFF00E676), isSmallScreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOptionCard('Crypto', Icons.currency_bitcoin, const Color(0xFFFFD700), isSmallScreen),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.1),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: isSmallScreen ? 28 : 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlist(bool isSmallScreen) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Watchlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        color: const Color(0xFF6C63FF),
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _investments.length,
                  separatorBuilder: (context, index) => SizedBox(height: isSmallScreen ? 8 : 12),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _itemAnimations[index],
                      builder: (context, child) {
                        final animationValue = _itemAnimations[index].value.clamp(0.0, 1.0);
                        
                        return Transform.scale(
                          scale: animationValue,
                          child: Transform.translate(
                            offset: Offset((1 - animationValue) * 100, 0),
                            child: Opacity(
                              opacity: animationValue,
                              child: _buildInvestmentItem(_investments[index], isSmallScreen),
                            ),
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

  Widget _buildInvestmentItem(Investment investment, bool isSmallScreen) {
    final isPositive = investment.change >= 0;
    
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
              color: investment.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: investment.color.withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Text(
                investment.symbol.substring(0, 2),
                style: TextStyle(
                  color: investment.color,
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  investment.symbol,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${investment.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? const Color(0xFF00E676) : const Color(0xFFFF5252),
                    size: isSmallScreen ? 12 : 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${investment.changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive ? const Color(0xFF00E676) : const Color(0xFFFF5252),
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Investment {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final double changePercent;
  final Color color;

  Investment({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.color,
  });
}

class ChartPainter extends CustomPainter {
  final double animation;

  ChartPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = <Offset>[];
    
    // Generate chart points
    for (int i = 0; i <= 20; i++) {
      final x = (i / 20) * size.width;
      final baseY = size.height * 0.5;
      final variance = math.sin((i + animation * 10) * 0.5) * size.height * 0.3;
      final y = baseY + variance;
      points.add(Offset(x, y));
    }

    // Create the path
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);

    // Draw gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF6C63FF).withOpacity(0.3),
          const Color(0xFF6C63FF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) => animation != oldDelegate.animation;
}
