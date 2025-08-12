import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _itemAnimations;

  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _darkModeEnabled = true;
  
  String _userName = 'Loading...';
  String _userEmail = 'Loading...';

  final List<ProfileMenuItem> _menuItems = [
    ProfileMenuItem(
      title: 'Account Settings',
      subtitle: 'Personal information & security',
      icon: Icons.person_outlined,
      color: const Color(0xFF6C63FF),
    ),
    ProfileMenuItem(
      title: 'Payment Methods',
      subtitle: 'Cards, banks & digital wallets',
      icon: Icons.payment,
      color: const Color(0xFF00E676),
    ),
    ProfileMenuItem(
      title: 'Security',
      subtitle: 'Privacy & authentication',
      icon: Icons.security,
      color: const Color(0xFFFFD700),
    ),
    ProfileMenuItem(
      title: 'Notifications',
      subtitle: 'Alerts & preferences',
      icon: Icons.notifications_outlined,
      color: const Color(0xFFFF5722),
    ),
    ProfileMenuItem(
      title: 'Support',
      subtitle: 'Help center & contact',
      icon: Icons.help_outlined,
      color: const Color(0xFF9C27B0),
    ),
    ProfileMenuItem(
      title: 'About',
      subtitle: 'App version & terms',
      icon: Icons.info_outlined,
      color: const Color(0xFF607D8B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _itemAnimations = List.generate(_menuItems.length + 3, (index) {
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
    _loadUserInfo();
  }
  
  void _loadUserInfo() async {
    final email = await AuthService.getUserEmail();
    final name = await AuthService.getUserName();
    
    setState(() {
      _userEmail = email ?? 'user@example.com';
      _userName = name ?? 'User';
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                
                // Profile Info
                _buildProfileInfo(isSmallScreen),
                
                // Quick Settings
                _buildQuickSettings(isSmallScreen),
                
                // Menu Items
                _buildMenuItems(isSmallScreen),
                
                // Logout Button
                _buildLogoutButton(isSmallScreen),
                
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _itemAnimations[0],
      builder: (context, child) {
        final animationValue = _itemAnimations[0].value.clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset(0, (1 - animationValue) * -50),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFF6C63FF)],
                    ).createShader(bounds),
                    child: Text(
                      'Profile',
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
                      Icons.edit,
                      color: Colors.white.withOpacity(0.8),
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo(bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _itemAnimations[1],
      builder: (context, child) {
        final animationValue = _itemAnimations[1].value.clamp(0.0, 1.0);
        
        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Opacity(
            opacity: animationValue,
            child: Container(
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
                    child: Row(
                      children: [
                        Container(
                          width: isSmallScreen ? 60 : 70,
                          height: isSmallScreen ? 60 : 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF00E676)],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: isSmallScreen ? 30 : 35,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 16 : 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userEmail,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFFFD700).withOpacity(0.2),
                                  border: Border.all(
                                    color: const Color(0xFFFFD700).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  'Premium Member',
                                  style: TextStyle(
                                    color: const Color(0xFFFFD700),
                                    fontSize: isSmallScreen ? 10 : 12,
                                    fontWeight: FontWeight.w600,
                                  ),
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickSettings(bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _itemAnimations[2],
      builder: (context, child) {
        final animationValue = _itemAnimations[2].value.clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset((1 - animationValue) * 100, 0),
          child: Opacity(
            opacity: animationValue,
            child: Container(
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
                          'Quick Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingItem(
                          'Notifications',
                          'Get alerts for transactions',
                          Icons.notifications_outlined,
                          _notificationsEnabled,
                          (value) => setState(() => _notificationsEnabled = value),
                          isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildSettingItem(
                          'Biometric Login',
                          'Use fingerprint or face ID',
                          Icons.fingerprint,
                          _biometricsEnabled,
                          (value) => setState(() => _biometricsEnabled = value),
                          isSmallScreen,
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildSettingItem(
                          'Dark Mode',
                          'App appearance preference',
                          Icons.dark_mode_outlined,
                          _darkModeEnabled,
                          (value) => setState(() => _darkModeEnabled = value),
                          isSmallScreen,
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

  Widget _buildSettingItem(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged, bool isSmallScreen) {
    return Row(
      children: [
        Container(
          width: isSmallScreen ? 40 : 45,
          height: isSmallScreen ? 40 : 45,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
            size: isSmallScreen ? 20 : 24,
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
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF6C63FF),
          inactiveThumbColor: Colors.white.withOpacity(0.5),
          inactiveTrackColor: Colors.white.withOpacity(0.2),
        ),
      ],
    );
  }

  Widget _buildMenuItems(bool isSmallScreen) {
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
                  'Settings',
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
                  itemCount: _menuItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: isSmallScreen ? 8 : 12),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _itemAnimations[index + 3],
                      builder: (context, child) {
                        final animationValue = _itemAnimations[index + 3].value.clamp(0.0, 1.0);
                        
                        return Transform.translate(
                          offset: Offset((1 - animationValue) * 100, 0),
                          child: Opacity(
                            opacity: animationValue,
                            child: _buildMenuItem(_menuItems[index], isSmallScreen),
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

  Widget _buildMenuItem(ProfileMenuItem item, bool isSmallScreen) {
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
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: item.color.withOpacity(0.2),
              ),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: isSmallScreen ? 16 : 18,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _itemAnimations[_itemAnimations.length - 1],
      builder: (context, child) {
        final animationValue = _itemAnimations[_itemAnimations.length - 1].value.clamp(0.0, 1.0);
        
        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: 16,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.8),
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1A1A3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5252),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    // Perform logout
                    await AuthService.logout();
                    
                    // Navigate to login screen
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                              child: child,
                            );
                          },
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5252).withOpacity(0.1),
                  foregroundColor: const Color(0xFFFF5252),
                  side: BorderSide(
                    color: const Color(0xFFFF5252).withOpacity(0.3),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 16 : 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
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

class ProfileMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  ProfileMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
