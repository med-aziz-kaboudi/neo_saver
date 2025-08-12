
import 'package:flutter/material.dart';
import 'package:neo_saver/screens/home_screen.dart';
import 'package:neo_saver/screens/wallet_screen.dart';
import 'package:neo_saver/screens/invest_screen.dart';
import 'package:neo_saver/screens/stats_screen.dart';
import 'package:neo_saver/screens/profile_screen.dart';
import 'package:neo_saver/components/navigation/custom_bottom_nav.dart';
import 'package:neo_saver/screens/amazing_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo Saver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
      ),
      home: const AmazingSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    WalletScreen(),
    InvestScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  static const double _sideMargin = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          Positioned(
            left: _sideMargin,
            right: _sideMargin,
            bottom: 5,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          ),
        ],
      ),
    );
  }
}
