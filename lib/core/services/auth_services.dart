// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_project/core/models/user_profile_model.dart';
import 'package:mobile_project/core/utils/routes.dart';
import 'package:mobile_project/core/models/user_auth_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient supabaseClient;
  AuthServices(this.supabaseClient);

  Session? get currentUserSession => supabaseClient.auth.currentSession;
  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw 'User is null!';
      }

      final userEmail = response.user!.email;

      // 1. Check if the email exists in the admin table
      final isAdmin =
          await supabaseClient
              .from('admin')
              .select()
              .eq('email', userEmail!)
              .maybeSingle();

      if (isAdmin != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.admin);
        return;
      }

      // 2. If not admin, check user type
      final userData =
          await supabaseClient
              .from('profiles')
              .select('type')
              .eq('id', response.user!.id)
              .single();

      if (userData['type'] == null) {
        throw 'User type not found!';
      }

      final userType = userData['type'];

      // Navigate based on usertype
      switch (userType) {
        case 'donor':
          Navigator.pushReplacementNamed(context, AppRoutes.donorHome);
          break;
        case 'recipient':
          Navigator.pushReplacementNamed(context, AppRoutes.recipientHome);
          break;
        default:
          throw 'Unknown user type!';
      }
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserAuthModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String usertype,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name, 'number': phone, 'type': usertype},
      );
      if (response.user == null) {
        throw 'User is null!';
      }

      return UserAuthModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserProfileModel> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserProfileModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
          name: currentUserSession!.user.userMetadata!['name'],
          phone: currentUserSession!.user.userMetadata!['number'],
        );
      }
      throw 'No current user session found!';
    } catch (e) {
      throw e.toString();
    }
  }
}
