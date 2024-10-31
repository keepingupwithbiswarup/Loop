import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/pages/createpost.dart';
import 'package:loopedin/pages/homepage.dart';
import 'package:loopedin/pages/notifications.dart';
import 'package:loopedin/pages/userprofile.dart';
import 'package:loopedin/pages/userview.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  onSearchChanged() {
    searchInFirestore(searchController.text);
  }

  Future<void> searchInFirestore(String searchText) async {
    print("Search text changed: ${searchController.text}");
    if (searchText.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    final result = await FirebaseFirestore.instance
        .collection(FirebaseConstants.userCollection)
        .where('profileName', isGreaterThanOrEqualTo: searchText)
        .where('profileName', isLessThanOrEqualTo: '$searchText\uf8ff')
        .get();
    setState(() {
      searchResults = result.docs;
    });
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: searchController,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.only(
                      left: 15,
                      top: 14,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color.fromRGBO(242, 242, 242, 1),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Search',
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 122, 122, 122),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final data =
                        searchResults[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserViewPage(user: data),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: data['profileImage'] != ""
                            ? CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  data['profileImage'],
                                ))
                            : const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  defAvatarPath,
                                )),
                        title: Text(
                          data['profileName'],
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['name'],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    );
                  },
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
              icon: const Icon(Icons.favorite_border_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const NotificationsPage(),
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
