import 'package:flutter/material.dart';

class CustomeBottomNavigationBar extends StatefulWidget {
  final List<BottomNavigationBarItem> bottomNavItems;
  final List<Widget> pages;

  const CustomeBottomNavigationBar({
    super.key,
    required this.bottomNavItems,
    required this.pages,
  });

  @override
  State<CustomeBottomNavigationBar> createState() =>
      _CustomBottomNavigationBar();
}

class _CustomBottomNavigationBar extends State<CustomeBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: widget.bottomNavItems,
      ),
      body: widget.pages[_currentIndex],
    );
  }
}
