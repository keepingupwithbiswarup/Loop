import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/controllers/authcontroller.dart';
import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/pages/userprofile.dart';
import 'package:loopedin/repository/authrepository.dart';
import 'package:loopedin/utils/showsnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends ConsumerWidget {
  SignUpPage({super.key});

  final passwordVisibilityProvider1 = StateProvider((ref) {
    return false;
  });
  final passwordVisibilityProvider2 = StateProvider((ref) {
    return false;
  });

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

  void signUp(BuildContext context, WidgetRef ref) async {
    if (password.text.trim().isEmpty || confirmpassword.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Password fields cannot be empty.');
      return;
    }

    if (email.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your email.');
    }
    if (fullname.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your name.');
    }
    if (username.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your username.');
    }

    if (password.text.trim() != confirmpassword.text.trim()) {
      showSnackBar(context: context, text: 'Passwords do not match.');
      return;
    }

    final success = await ref.read(authControllerProvider).signUp(
        email: email.text.trim(),
        password: password.text.trim() == confirmpassword.text.trim()
            ? password.text.trim()
            : '',
        name: fullname.text.trim(),
        username: username.text.trim().toLowerCase(),
        context: context,
        ref: ref);

    if (success) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
    ref.read(isLoadingProvider.notifier).state = false;
  }

  final TextEditingController email = TextEditingController();
  final password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final fullname = TextEditingController();
  final TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisibility1 = ref.watch(passwordVisibilityProvider1);
    final passwordVisibility2 = ref.watch(passwordVisibilityProvider2);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Sign Up Now",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        "Please fill all the fields to continue",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 122, 122, 122),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
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
                        controller: fullname,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.only(left: 15, bottom: 0),
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          focusedBorder: InputBorder.none,
                          hintText: 'Name',
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
                        controller: username,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.only(left: 15, bottom: 0),
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          focusedBorder: InputBorder.none,
                          hintText: 'Username',
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
                                    .read(passwordVisibilityProvider1.notifier)
                                    .state = !passwordVisibility1;
                              },
                              child: passwordVisibility1
                                  ? const Icon(Icons.remove_red_eye)
                                  : const Icon(Icons.visibility_off)),
                        ),
                        obscureText: !passwordVisibility1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            'Must contain a number and least of 6 characters',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 12)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.black),
                        controller: confirmpassword,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            left: 15,
                            top: 14,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(242, 242, 242, 1),
                          focusedBorder: InputBorder.none,
                          hintText: 'Confirm Password',
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 122, 122, 122),
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                ref
                                    .read(passwordVisibilityProvider2.notifier)
                                    .state = !passwordVisibility2;
                              },
                              child: passwordVisibility2
                                  ? const Icon(Icons.remove_red_eye)
                                  : const Icon(Icons.visibility_off)),
                        ),
                        obscureText: !passwordVisibility2,
                      ),
                      const SizedBox(
                        height: 35,
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
                            signUp(context, ref);
                          },
                          child: Text(
                            "Register",
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
                                    'Sign Up With Google',
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
                        height: 40,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "Already have an account? ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 13)),
                              TextSpan(
                                text: "Login",
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: const Color.fromRGBO(237, 12, 52, 1),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
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
