import 'package:flutter/material.dart';
import 'package:mobile_project/core/constants.dart';
import 'package:mobile_project/views/recipient/create_request.dart';

class RecipientHomeScreen extends StatefulWidget {
  const RecipientHomeScreen({super.key});

  @override
  State<RecipientHomeScreen> createState() => _RecipientHomeScreenState();
}

class _RecipientHomeScreenState extends State<RecipientHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: Text('Your Requests')),
          const Center(child: Text('Profile')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateRequestScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
