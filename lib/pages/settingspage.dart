import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/controllers/authcontroller.dart';
import 'package:loopedin/pages/editprofile.dart';
import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/utils/showsnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void logout() async {
    ref.read(isLoadingProvider.notifier).state = true;
    final success = await ref.read(authControllerProvider).logout(ref);

    if (success) {
      // Once the logout is successful, reset the loading state and navigate
      var prefs = await SharedPreferences.getInstance();
      prefs.remove('LoggedIn');
      ref.read(isLoggedInProvider.notifier).state = false;
      // Navigate to the login page
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        ref.read(isLoadingProvider.notifier).state = false;
      }
    } else {
      // Reset the loading state if logout fails
      ref.read(isLoadingProvider.notifier).state = false;

      // Show an error message or take appropriate action
      showSnackBar(context: context, text: "Failed to log out");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "Settings and activity",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your account',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 122, 122, 122),
                      ),
                ),
                Image.asset(
                  appLogoPath,
                  height: 50,
                  width: 50,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(),
              child: Divider(
                color: Color.fromARGB(255, 228, 228, 228),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const EditProfilePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin =
                          Offset(1.0, 0.0); // Slide from right to left
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(
                  Icons.edit,
                  size: 20,
                ),
                title: Text(
                  "Edit Profile",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 18),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const Icon(
                Icons.logout,
                size: 20,
                color: Color.fromRGBO(237, 12, 52, 1),
              ),
              title: GestureDetector(
                onTap: () {
                  logout();
                },
                child: Text(
                  "Log Out",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 18,
                        color: const Color.fromRGBO(237, 12, 52, 1),
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
