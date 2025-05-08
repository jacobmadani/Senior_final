import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/user_profile.dart';
import 'package:mobile_project/core/services/auth_services.dart';
import 'package:mobile_project/core/utils/constants.dart';
import 'package:mobile_project/core/utils/routes.dart';
import 'package:mobile_project/features/profile/widget/profile_info_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthServices authServices = AuthServices(Supabase.instance.client);
    UserProfile currentUser = UserProfile(
      name: authServices.currentUserSession?.user.userMetadata!['name'] ?? '',
      email: authServices.currentUserSession?.user.email ?? '',
      phone:
          authServices.currentUserSession?.user.userMetadata!['number'] ?? '',
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            currentUser.name,
            // _currentUser.name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            currentUser.email,
            // _currentUser.email,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ProfileInfoItem(icon: Icons.person, text: currentUser.name),
          ProfileInfoItem(icon: Icons.email, text: currentUser.email),
          ProfileInfoItem(icon: Icons.phone, text: currentUser.phone),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Log Out'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text('Contact Us'),
                          content: const Text(
                            'For support, email us at:\nsupport@unitedhope.org\n\nOr call: +961-71-123456',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
                icon: const Icon(Icons.contact_support),
                label: const Text('Contact Us'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
