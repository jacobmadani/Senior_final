import 'package:flutter/material.dart';

class AdminUserListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {
      'name': 'Jane Doe',
      'email': 'jane@example.com',
      'type': 'donor',
      'status': 'active',
    },
    {
      'name': 'Ali Youssef',
      'email': 'ali@site.com',
      'type': 'recipient',
      'status': 'flagged',
    },
    {
      'name': 'Scam User',
      'email': 'scam@fake.com',
      'type': 'scammer',
      'status': 'banned',
    },
  ];

  AdminUserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👨‍💼 Admin Dashboard - Manage Users'),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = users[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header: Name & Email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 28),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user['email'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Chip(
                          label: Text(
                            user['status'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: _getStatusColor(user['status']),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Role + Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.badge_outlined),
                            const SizedBox(width: 4),
                            Text(
                              "Type: ${user['type']}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Tooltip(
                              message: 'View User',
                              child: IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  // View logic
                                },
                              ),
                            ),
                            Tooltip(
                              message: 'Ban User',
                              child: IconButton(
                                icon: const Icon(Icons.block),
                                color: Colors.red,
                                onPressed: () {
                                  // Ban logic
                                },
                              ),
                            ),
                            Tooltip(
                              message: 'Promote User',
                              child: IconButton(
                                icon: const Icon(Icons.upgrade),
                                color: Colors.indigo,
                                onPressed: () {
                                  // Promote logic
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green.shade100;
      case 'flagged':
        return Colors.orange.shade100;
      case 'banned':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}
