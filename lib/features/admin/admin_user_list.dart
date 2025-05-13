// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/user_profile.dart';
import 'package:mobile_project/core/services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUserListScreen extends StatefulWidget {
  const AdminUserListScreen({super.key});

  @override
  State<AdminUserListScreen> createState() => _AdminUserListScreenState();
}

class _AdminUserListScreenState extends State<AdminUserListScreen> {
  final AuthServices authServices = AuthServices(Supabase.instance.client);
  List<UserProfile> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await Supabase.instance.client.from('profiles').select();

    final List<UserProfile> loadedUsers =
        (response as List).map((user) {
          return UserProfile(
            name: user['name'] ?? '',
            email: user['email'] ?? '',
            phone: user['number'] ?? '',
            usertype: user['type'] ?? '',
            userId: user['id'],
          );
        }).toList();

    setState(() {
      users = loadedUsers;
      isLoading = false;
    });
  }

  Future<void> deleteUser(String userId) async {
    try {
      // ignore: unused_local_variable
      final result = await Supabase.instance.client
          .from('profiles')
          .delete()
          .eq('id', userId);

      // `result` is typically a List or null if nothing matched.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted from profiles')),
      );

      fetchUsers(); // refresh the list
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  Future<void> deleteUserFromAuth(String userId) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'delete-user',
        body: {'user_id': userId},
      );

      if (response.status == 200) {
        debugPrint('User deleted from auth.');
      } else {
        debugPrint('Auth deletion failed: ${response.data}');
        throw Exception('Auth deletion failed: ${response.data}');
      }
    } catch (e) {
      debugPrint('Error in deleteUserFromAuth: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👨‍💼 Admin Dashboard - Manage Users'),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          user.email,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Tooltip(
                                  message: 'Delete User',
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () async {
                                      final confirmed = await showDialog(
                                        context: context,
                                        builder:
                                            (_) => AlertDialog(
                                              title: const Text(
                                                'Confirm Deletion',
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete ${user.name}?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                ),
                                                TextButton(
                                                  child: const Text('Delete'),
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                ),
                                              ],
                                            ),
                                      );

                                      if (confirmed == true) {
                                        try {
                                          await deleteUser(
                                            user.userId!,
                                          ); // from profiles
                                          await deleteUserFromAuth(
                                            user.userId!,
                                          ); // from auth
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'User fully deleted',
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Deletion failed: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// Role
                            Row(
                              children: [
                                const Icon(Icons.badge_outlined),
                                const SizedBox(width: 4),
                                Text(
                                  "Type: ${user.usertype}",
                                  style: const TextStyle(fontSize: 14),
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
}
