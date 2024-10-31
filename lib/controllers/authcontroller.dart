import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loopedin/repository/authrepository.dart';
import 'package:loopedin/utils/showsnackbar.dart';

final authControllerProvider = Provider((ref) {
  return AuthController(authRepository: ref.read(authRepositoryProvider));
});

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;
  Future<bool> continueWithGoogle(WidgetRef ref) async {
    try {
      final success = await _authRepository.signInWithGoogle(ref);

      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout(WidgetRef ref) async {
    try {
      await _authRepository.signOutWithGoogle(ref);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final success = await _authRepository.signUpWithEmail(
          email: email,
          password: password,
          name: name,
          username: username,
          context: context,
          ref: ref);
      return success;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions and show a snackbar
      showSnackBar(context: context, text: e.message ?? 'An error occurred');
      return false;
    } catch (e) {
      // Handle any other exceptions and show a generic snackbar
      showSnackBar(context: context, text: 'An unexpected error occurred');
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final success = await _authRepository.signInWithEmail(
          email: email, password: password, context: context, ref: ref);
      return success;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions and show a snackbar
      showSnackBar(context: context, text: e.message ?? 'An error occurred');
      return false;
    } catch (e) {
      // Handle any other exceptions and show a generic snackbar
      showSnackBar(context: context, text: 'An unexpected error occurred');
      return false;
    }
  }

  Future<bool> forgotPassword(
      {required String email, required BuildContext context}) async {
    try {
      final success =
          await _authRepository.resetPassword(email: email, context: context);
      return success;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, text: e.message!);
      return false;
    } catch (e) {
      showSnackBar(context: context, text: 'An unexpected error occurred');
      return false;
    }
  }
}
