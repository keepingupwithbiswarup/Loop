import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/pages/createpost.dart';
import 'package:loopedin/pages/homepage.dart';
import 'package:loopedin/pages/searchpage.dart';
import 'package:loopedin/pages/userprofile.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
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
          "Notifications",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0,
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        height: 55,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
                grade: 4,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const CreatePostPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin =
                          Offset(0.0, 1.0); // Slide from right to left
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
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
