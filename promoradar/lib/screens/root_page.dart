import 'package:flutter/material.dart';
import 'package:promoradar/screens/home_page.dart';
import 'package:promoradar/screens/profile_page.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'search_page.dart'; // 👈 importá tu widget

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PromoRadar")),
      body: _pages[_currentIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
