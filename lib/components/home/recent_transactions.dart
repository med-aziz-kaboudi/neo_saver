import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late List<Animation<double>> _itemAnimations;

  final List<Transaction> _transactions = [
    Transaction(
      title: 'Netflix Subscription',
      subtitle: 'Entertainment • Monthly',
      amount: -15.99,
      date: 'Today',
      icon: Icons.play_circle_filled,
      color: const Color(0xFFE50914),
    ),
    Transaction(
      title: 'Salary Deposit',
      subtitle: 'TechCorp Inc.',
      amount: 3500.00,
      date: 'Yesterday',
      icon: Icons.work,
      color: const Color(0xFF00E676),
    ),
    Transaction(
      title: 'Coffee Shop',
      subtitle: 'Starbucks • Food & Drinks',
      amount: -12.50,
      date: '2 days ago',
      icon: Icons.local_cafe,
      color: const Color(0xFF00704A),
    ),
    Transaction(
      title: 'Investment Return',
      subtitle: 'Stock Portfolio',
      amount: 127.30,
      date: '3 days ago',
      icon: Icons.trending_up,
      color: const Color(0xFF9C27B0),
    ),
    Transaction(
      title: 'Gas Station',
      subtitle: 'Shell • Transportation',
      amount: -45.20,
      date: '4 days ago',
      icon: Icons.local_gas_station,
      color: const Color(0xFFFF5722),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create staggered animations for each transaction
    _itemAnimations = List.generate(_transactions.length, (index) {
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
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
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
                        'Recent Transactions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Navigate to all transactions
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: const Color(0xFF6C63FF).withOpacity(0.8),
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: isSmallScreen ? 16 : 20),
                
                // Transactions list
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _transactions.length,
                  separatorBuilder: (context, index) => SizedBox(height: isSmallScreen ? 8 : 12),
                  itemBuilder: (context, index) {
                    return _buildTransactionItem(index, isSmallScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(int index, bool isSmallScreen) {
    final transaction = _transactions[index];
    
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
              child: Container(
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
                    // Transaction icon
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        final shimmerValue = _shimmerController.value;
                        final glowIntensity = 0.5 + math.sin(shimmerValue * 2 * math.pi + index) * 0.3;
                        
                        return Container(
                          width: isSmallScreen ? 45 : 50,
                          height: isSmallScreen ? 45 : 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: transaction.color.withOpacity(0.1),
                            border: Border.all(
                              color: transaction.color.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: transaction.color.withOpacity(0.1 * glowIntensity),
                                blurRadius: 8 * glowIntensity,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            transaction.icon,
                            color: transaction.color,
                            size: isSmallScreen ? 22 : 24,
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    
                    // Transaction details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.title,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Amount and date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          transaction.amount > 0 
                              ? '+\$${transaction.amount.toStringAsFixed(2)}'
                              : '-\$${transaction.amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: transaction.amount > 0 
                                ? const Color(0xFF00E676)
                                : const Color(0xFFFF5252),
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaction.date,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: isSmallScreen ? 10 : 12,
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
    );
  }
}

class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final IconData icon;
  final Color color;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });
}
