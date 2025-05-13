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
    try {
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
    } catch (e) {
      debugPrint('Error fetching users: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load users: $e')));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      print('Deleting user from profiles table. User ID: $userId');

      // Delete from profiles table
      final result = await Supabase.instance.client
          .from('profiles')
          .delete()
          .eq('id', userId);

      print('Delete profile result: $result');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted from profiles')),
      );
    } catch (e) {
      debugPrint('Error deleting user from profiles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete from profiles: $e')),
      );
      rethrow;
    }
  }

  Future<void> deleteUserFromAuth(String userId) async {
    try {
      print('Attempting to delete user from auth. User ID: $userId');

      // Validate the user ID
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID is null or empty');
      }

      // Check if ID is in UUID format (contains hyphens and is the right length)
      if (!userId.contains('-') || userId.length < 30) {
        print('Warning: User ID may not be in proper UUID format: $userId');
      }

      // Call the Edge Function to delete the user from auth
      final response = await Supabase.instance.client.functions.invoke(
        'delete-user',
        method: HttpMethod.post,
        body: {'user_id': userId},
      );

      print('Edge function response: ${response.data}');

      // Check if the function call was successful
      if (response.status != 200) {
        final errorData =
            response.data is Map ? response.data : {'error': 'Unknown error'};
        throw Exception(
          'Function error: ${errorData['error'] ?? 'Unknown error'}',
        );
      }

      print('Successfully deleted user from auth. User ID: $userId');
    } catch (e) {
      debugPrint('Error deleting user from auth: $e');
      rethrow;
    }
  }

  Future<void> completeUserDeletion(UserProfile user) async {
    try {
      if (user.userId == null || user.userId!.isEmpty) {
        throw Exception('User ID is missing');
      }

      print(
        'Starting complete deletion process for user: ${user.name} (ID: ${user.userId})',
      );

      // Step 1: Delete from profiles table first
      await deleteUser(user.userId!);
      print('✅ Successfully deleted user from profiles table');

      // Step 2: Delete from auth table via Edge Function
      await deleteUserFromAuth(user.userId!);
      print('✅ Successfully deleted user from auth table');

      // Success notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User completely deleted from both profiles and auth'),
        ),
      );

      // Refresh the user list
      fetchUsers();
    } catch (e) {
      print('❌ Error during complete user deletion: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User deletion failed: $e')));
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
              : users.isEmpty
              ? const Center(child: Text('No users found'))
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
                            /// Header: Name & Email with ID
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person_outline,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
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
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'ID: ${user.userId}',
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
                                                'Are you sure you want to delete ${user.name}?\n\nThis will remove the user from both the profiles table and auth system.\n\nUser ID: ${user.userId}',
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
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
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
                                        // Use the complete deletion method
                                        await completeUserDeletion(user);
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
