import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardController;
  late List<Animation<double>> _cardAnimations;
  
  int _selectedCardIndex = 0;

  final List<WalletCard> _cards = [
    WalletCard(
      name: 'Primary Card',
      number: '**** **** **** 1234',
      balance: 12547.89,
      type: 'VISA',
      color: const LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)],
      ),
    ),
    WalletCard(
      name: 'Savings Card',
      number: '**** **** **** 5678',
      balance: 8234.56,
      type: 'MASTERCARD',
      color: const LinearGradient(
        colors: [Color(0xFF00E676), Color(0xFF4CAF50)],
      ),
    ),
    WalletCard(
      name: 'Investment Card',
      number: '**** **** **** 9012',
      balance: 15678.90,
      type: 'AMERICAN EXPRESS',
      color: const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFF9800)],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimations = List.generate(_cards.length, (index) {
      final start = (index * 0.2).clamp(0.0, 1.0);
      final end = (start + 0.6).clamp(0.0, 1.0);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardController.dispose();
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
                
                // Cards Section
                _buildCardsSection(isSmallScreen),
                
                // Quick Actions
                _buildQuickActions(isSmallScreen),
                
                // Transaction History
                _buildTransactionHistory(isSmallScreen),
                
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
              'My Wallet',
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
              Icons.add,
              color: Colors.white.withOpacity(0.8),
              size: isSmallScreen ? 20 : 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsSection(bool isSmallScreen) {
    return Container(
      height: isSmallScreen ? 200 : 220,
      child: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _selectedCardIndex = index;
          });
        },
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _cardAnimations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _cardAnimations[index].value.clamp(0.1, 1.0),
                child: Transform.translate(
                  offset: Offset(0, (1 - _cardAnimations[index].value.clamp(0.0, 1.0)) * 50),
                  child: Opacity(
                    opacity: _cardAnimations[index].value.clamp(0.0, 1.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 20,
                        vertical: 10,
                      ),
                      child: _buildCreditCard(_cards[index], isSmallScreen),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCreditCard(WalletCard card, bool isSmallScreen) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
          decoration: BoxDecoration(
            gradient: card.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    card.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    card.type,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                card.number,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BALANCE',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${card.balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.contactless,
                    color: Colors.white.withOpacity(0.8),
                    size: isSmallScreen ? 24 : 28,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 16,
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
                  'Quick Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionItem(Icons.send, 'Send', const Color(0xFF6C63FF), isSmallScreen),
                    _buildActionItem(Icons.call_received, 'Request', const Color(0xFF00E676), isSmallScreen),
                    _buildActionItem(Icons.payment, 'Pay', const Color(0xFFFF9800), isSmallScreen),
                    _buildActionItem(Icons.swap_horiz, 'Exchange', const Color(0xFF9C27B0), isSmallScreen),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color, bool isSmallScreen) {
    return Column(
      children: [
        Container(
          width: isSmallScreen ? 50 : 60,
          height: isSmallScreen ? 50 : 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: isSmallScreen ? 24 : 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory(bool isSmallScreen) {
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
                      'Recent Transactions',
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
                _buildTransactionItem('Spotify Premium', 'Music Subscription', -9.99, 'Today', Icons.music_note, const Color(0xFF1DB954), isSmallScreen),
                _buildTransactionItem('Grocery Store', 'Food & Drinks', -127.45, 'Yesterday', Icons.shopping_cart, const Color(0xFF4CAF50), isSmallScreen),
                _buildTransactionItem('Salary Deposit', 'TechCorp Inc.', 3500.00, '2 days ago', Icons.work, const Color(0xFF00E676), isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String title, String subtitle, double amount, String date, IconData icon, Color iconColor, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 40 : 45,
            height: isSmallScreen ? 40 : 45,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withOpacity(0.3),
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: isSmallScreen ? 20 : 22,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
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
                amount > 0 ? '+\$${amount.toStringAsFixed(2)}' : '-\$${amount.abs().toStringAsFixed(2)}',
                style: TextStyle(
                  color: amount > 0 ? const Color(0xFF00E676) : const Color(0xFFFF5252),
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: isSmallScreen ? 10 : 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletCard {
  final String name;
  final String number;
  final double balance;
  final String type;
  final LinearGradient color;

  WalletCard({
    required this.name,
    required this.number,
    required this.balance,
    required this.type,
    required this.color,
  });
}
