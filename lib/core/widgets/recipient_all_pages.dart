import 'package:flutter/material.dart';
import 'package:mobile_project/core/widgets/custome_bottom_navigation_bar.dart';
import 'package:mobile_project/features/profile/profile.dart';
import 'package:mobile_project/features/recipient/recipient_home.dart';

class RecipientAllPages extends StatelessWidget {
  const RecipientAllPages({super.key});

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Requests'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];
    List<Widget> pages = [RecipientHomeScreen(), Profile()];
    return CustomeBottomNavigationBar(
      bottomNavItems: bottomNavItems,
      pages: pages,
    );
  }
}
