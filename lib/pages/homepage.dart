import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/pages/createpost.dart';
import 'package:loopedin/pages/notifications.dart';
import 'package:loopedin/pages/searchpage.dart';

import 'package:loopedin/pages/userprofile.dart';

import 'package:loopedin/repository/authrepository.dart';
import 'package:loopedin/utils/postcard.dart';

String getTimeAgo(Timestamp timestamp) {
  final now = Timestamp.now();
  final difference = now.seconds - timestamp.seconds;

  if (difference < 60) {
    return '$difference seconds ago';
  } else if (difference < 3600) {
    return '${(difference / 60).floor()} minutes ago';
  } else if (difference < 86400) {
    return '${(difference / 3600).floor()} hours ago';
  } else {
    return '${(difference / 86400).floor()} days ago';
  }
}

final postProvider = FutureProvider<List<SocialMediaPost>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection(FirebaseConstants.postCollection)
      .get();

  List<SocialMediaPost> posts = [];

  for (var doc in snapshot.docs) {
    // Fetch the user document based on ownerId
    final userSnapshot = await FirebaseFirestore.instance
        .collection(FirebaseConstants.userCollection)
        .where('userId', isEqualTo: doc['ownerId'])
        .get();

    // Ensure there is at least one user document
    String username = '';
    String dpUrl = '';
    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data();
      username = userData['profileName'] ?? '';
      dpUrl = userData['profileImage'] ?? '';
    }

    final data = doc.data();
    bool videoCheck = await isVideo(data['postUrl']);

    posts.add(SocialMediaPost(
      postId: data['postId'],
      likes: (data['likes'] as List).length,
      username: username,
      dpUrl: dpUrl,
      ownerId: data['ownerId'],
      imageUrl: data['postUrl'] ?? '',
      caption: data['caption'] ?? '',
      isVideoCheck: videoCheck,
      time: getTimeAgo(data['timestamp']),
    ));
  }

  return posts;
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider);
    final posts = ref.watch(postProvider);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      appLogoPath,
                      height: 50,
                      width: 85,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.favorite_border_outlined,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.add_circle_outline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: const Color.fromRGBO(237, 12, 52, 1),
                  backgroundColor: Colors.white,
                  edgeOffset: 40,
                  onRefresh: () async {
                    ref.refresh(postProvider);
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 84,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 43,
                                      backgroundImage: user!.profileImage != ""
                                          ? NetworkImage(user.profileImage)
                                          : const AssetImage(defAvatarPath),
                                    ),
                                    Positioned(
                                      top: 55,
                                      left: 58,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: const Icon(
                                            Icons.add_circle_sharp,
                                            size: 29,
                                            color:
                                                Color.fromRGBO(237, 12, 52, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                // Other items
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: CircleAvatar(
                                    radius: 43,
                                    backgroundImage: user!.profileImage != ""
                                        ? NetworkImage(user.profileImage)
                                        : const AssetImage(defAvatarPath),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Divider(
                          color: Color.fromARGB(255, 243, 243, 243),
                        ),
                      ),
                      Expanded(
                        child: posts.when(
                          data: (posts) {
                            return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return post;
                              },
                            );
                          },
                          error: (error, _) =>
                              Center(child: Text('Error: $error')),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
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
              icon: const Icon(Icons.home),
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const CreatePostPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
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
