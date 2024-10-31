import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/controllers/authcontroller.dart';

import 'package:loopedin/pages/forgotpass.dart';
import 'package:loopedin/pages/signup.dart';
import 'package:loopedin/pages/userprofile.dart';
import 'package:loopedin/repository/authrepository.dart';

import 'package:loopedin/utils/showsnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final isLoggedInProvider = StateProvider<bool>((ref) {
  return false;
});

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(authControllerProvider).continueWithGoogle(ref);

    if (success) {
      final user2 = await ref.read(userNotifierProvider.notifier).fetchUserData(
          FirebaseAuth.instance,
          FirebaseFirestore.instance
              .collection(FirebaseConstants.userCollection));

      ref.read(userNotifierProvider.notifier).setUser(user2!);

      var prefs = await SharedPreferences.getInstance();
      ref.read(isLoggedInProvider.notifier).state = true;
      prefs.setBool('LoggedIn', ref.read(isLoggedInProvider.notifier).state);
      prefs.setString("UID", user2.userId);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  void signIn(BuildContext context, WidgetRef ref) async {
    if (email.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your email.');
    }
    if (password.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Password Field cannot be empty');
      return;
    }
    final success = await ref.read(authControllerProvider).signIn(
        email: email.text.trim(),
        password: password.text.trim(),
        context: context,
        ref: ref);

    if (success) {
      final user2 = await ref.read(userNotifierProvider.notifier).fetchUserData(
          FirebaseAuth.instance,
          FirebaseFirestore.instance
              .collection(FirebaseConstants.userCollection));
      ref.read(userNotifierProvider.notifier).setUser(user2!);

      var prefs = await SharedPreferences.getInstance();
      ref.read(isLoggedInProvider.notifier).state = true;
      prefs.setBool('LoggedIn', ref.read(isLoggedInProvider.notifier).state);
      prefs.setString("UID", user2.userId);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  final passwordVisibilityProvider = StateProvider<bool>((ref) {
    return false;
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisibility = ref.watch(passwordVisibilityProvider);
    final isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          loginimg,
                          width: double.infinity,
                          height: 300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Login Now",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        "Please enter the details to continue",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 122, 122, 122),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.black),
                        controller: email,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.only(left: 15, bottom: 0),
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          focusedBorder: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 122, 122, 122),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.black),
                        controller: password,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            left: 15,
                            top: 14,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          focusedBorder: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 122, 122, 122),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                ref
                                    .read(passwordVisibilityProvider.notifier)
                                    .state = !passwordVisibility;
                              },
                              child: passwordVisibility
                                  ? const Icon(Icons.remove_red_eye)
                                  : const Icon(Icons.visibility_off)),
                        ),
                        obscureText: !passwordVisibility,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.montserrat(
                                  color: const Color.fromRGBO(237, 12, 52, 1),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(
                                  Size(double.infinity, 50)),
                              backgroundColor: WidgetStatePropertyAll(
                                  Color.fromRGBO(237, 12, 52, 1))),
                          onPressed: () {
                            signIn(context, ref);
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text("Or",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 20)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(220, 50),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal:
                                        20), // Padding for button height
                                backgroundColor: Theme.of(context)
                                    .scaffoldBackgroundColor, // Button background color
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .color!), // Border color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded corners
                                ),
                              ),
                              onPressed: () {
                                signInWithGoogle(context, ref);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/google_logo.png',
                                    height: 30,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'Continue with Google',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "Don't have an account? ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 13)),
                              TextSpan(
                                text: "Register",
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: const Color.fromRGBO(237, 12, 52, 1),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
