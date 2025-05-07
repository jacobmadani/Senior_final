import 'package:flutter/material.dart';
import 'package:mobile_project/core/widgets/custome_bottom_navigation_bar.dart';
import 'package:mobile_project/features/donor/widgets/donar_imports.dart';
import 'package:mobile_project/features/profile/profile.dart';

class DonationAllPage extends StatelessWidget {
  const DonationAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Requests'),
      BottomNavigationBarItem(
        icon: Icon(Icons.volunteer_activism),
        label: 'Donations',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];
    List<Widget> pages = [
      DonorPage(),
      Profile(),
      // DonationPage(),
      Profile(),
    ];
    return CustomeBottomNavigationBar(
      bottomNavItems: bottomNavItems,
      pages: pages,
    );
  }
}
