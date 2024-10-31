import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/pages/signup.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    appLogoPath,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 120,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    splashimg,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Engage & Create",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 10),
                    child: Text(
                      "Now it is easy to connect with your friends and create an album of memories. Find your loop.",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 122, 122, 122),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          minimumSize:
                              WidgetStatePropertyAll(Size(double.infinity, 50)),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromRGBO(237, 12, 52, 1))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        "Get Started",
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.titleSmall),
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.montserrat(
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
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
