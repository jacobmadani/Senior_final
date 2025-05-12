import 'package:flutter/material.dart';
import 'package:mobile_project/features/admin/admin_request_list.dart';
import 'package:mobile_project/features/admin/admin_user_list.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Requests'), Tab(text: 'Users')],
          ),
        ),
        body: TabBarView(children: [AdminRequestList(), AdminUserListScreen()]),
      ),
    );
  }
}
