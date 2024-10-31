import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loopedin/constants/constants.dart';

import 'package:loopedin/pages/homepage.dart';
import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/pages/notifications.dart';
import 'package:loopedin/pages/searchpage.dart';
import 'package:loopedin/pages/settingspage.dart';
import 'package:loopedin/pages/userprofile.dart';

class UserViewPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;
  const UserViewPage({super.key, required Map<String, dynamic> user})
      : userData = user;

  @override
  UserViewPageState createState() => UserViewPageState();
}

class UserViewPageState extends ConsumerState<UserViewPage> {
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
    final isLoading = ref.watch(isLoadingProvider);
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back_ios_new),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 22),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "@${widget.userData['profileName']}",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: SlantingClipper(),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          widget.userData['profileImage'] != ""
                              ? Image.network(
                                  widget.userData['profileImage'],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  defBannerPath,
                                  fit: BoxFit.cover,
                                ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black
                                  .withOpacity(0.3), // Transparent overlay
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Container(
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 25,
                            offset: const Offset(0, 15),
                          )
                        ]),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: widget.userData['profileImage'] != ""
                              ? NetworkImage(widget.userData['profileImage'])
                              : const AssetImage(defAvatarPath),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    right: 30,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SettingsPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(
                                    1.0, 0.0); // Slide from right to left
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
                        child: const Icon(Icons.more_vert)),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.userData['name'],
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 35),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                widget.userData['bio'],
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 17),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(0),
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      side: WidgetStatePropertyAll(BorderSide()),
                    ),
                    child: Text(
                      'Message',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(0),
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(237, 12, 52, 1)),
                      side: WidgetStatePropertyAll(
                          BorderSide(color: Color.fromRGBO(237, 12, 52, 1))),
                    ),
                    child: Text(
                      'Follow',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Followers",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 155, 155, 155),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "252k",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Following",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 155, 155, 155),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "358",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Posts",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 155, 155, 155),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "115",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 28.0, right: 28, top: 30, bottom: 10),
                child: Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "PHOTOS",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                    ),
                    Text(
                      "VIDEOS",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 155, 155, 155),
                      ),
                    ),
                    Text(
                      "POSTS",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 155, 155, 155),
                      ),
                    ),
                    Text(
                      "ABOUT",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 155, 155, 155),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 28.0, right: 28, top: 10, bottom: 10),
                child: Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                ),
              ),
            ],
          ),
        ),
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
              icon: const Icon(Icons.search),
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
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const NotificationsPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0);
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
              icon: const Icon(Icons.account_circle),
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

class SlantingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height - 80); // Adjust this value for slant
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
