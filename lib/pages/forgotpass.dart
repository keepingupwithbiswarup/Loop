import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/controllers/authcontroller.dart';
import 'package:loopedin/pages/signup.dart';
import 'package:loopedin/utils/showsnackbar.dart';

class ForgotPasswordPage extends ConsumerWidget {
  ForgotPasswordPage({super.key});
  final TextEditingController email = TextEditingController();
  void resetPassword(BuildContext context, WidgetRef ref) async {
    if (email.text.trim().isEmpty) {
      showSnackBar(context: context, text: 'Please enter your email.');
    }
    final success = await ref
        .read(authControllerProvider)
        .forgotPassword(email: email.text.trim(), context: context);
    if (success) {
      showSnackBar(
          context: context,
          text:
              'We have sent you a link to change your password. Please check your email.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Image.asset(
                  appLogoPath,
                  width: 250,
                  height: 50,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Oh, no!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'I forgot',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  'Enter your email we\'ll send you a link to change to a new password',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  prefixIconColor: Theme.of(context).primaryColor,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 194, 194, 194),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 52, 51, 65),
                    ),
                  ),
                  hintText: 'Email',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  resetPassword(context, ref);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  foregroundColor:
                      Theme.of(context).textTheme.bodyMedium!.color,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text('Forgot Password'),
              ),
              const SizedBox(
                height: 200,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ', // Main text
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 16), // Default style
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "Sign Up", // The part you want to style differently
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: const Color.fromARGB(255, 52, 51, 65),
                                fontSize: 16,
                              ), // Bold style
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
