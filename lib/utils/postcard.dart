import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/utils/video.dart';

void _showPersistentBottomSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _showDialog(context, postId);
              },
              child: Text('Delete Post',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: const Color.fromRGBO(237, 12, 52, 1))),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> deletePost(String postId) async {
  print(postId);
  await FirebaseFirestore.instance
      .collection(FirebaseConstants.postCollection)
      .doc(postId)
      .delete();
  print("Successfully deleted");
}

Future<void> _showDialog(BuildContext context, String postId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Please Confirm'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Are you sure you want to delete this post?',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Delete',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: const Color.fromRGBO(237, 12, 52, 1)),
            ),
            onPressed: () async {
              await deletePost(postId);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<bool> isVideo(String url) async {
  try {
    // Get a reference from the URL
    final ref = FirebaseStorage.instance.refFromURL(url);

    // Get metadata
    final metadata = await ref.getMetadata();

    // Check content type
    print(metadata.contentType);
    return metadata.contentType?.startsWith('video/') ?? false;
  } catch (e) {
    print('Error fetching metadata: $e');
    return false; // In case of an error, assume it's not a video
  }
}

class SocialMediaPost extends StatelessWidget {
  final String imageUrl;
  final String dpUrl;
  final String username;
  final String time;
  final String caption;
  final String ownerId;
  final String postId;
  final int likes;
  final bool isVideoCheck;

  const SocialMediaPost({
    super.key,
    required this.ownerId,
    required this.postId,
    required this.imageUrl,
    required this.dpUrl,
    required this.username,
    required this.time,
    required this.likes,
    required this.caption,
    required this.isVideoCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isVideoCheck
              ? LoopingVideoPlayer2(videoUrl: imageUrl)
              : CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(dpUrl),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 122, 122, 122),
                            ),
                      ),
                    ],
                  ),
                ),
                // Text(
                //   '$likes likes',
                //   style: Theme.of(context).textTheme.titleSmall,
                // ),
                IconButton(
                  icon: const Icon(Icons.favorite_border_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                FirebaseAuth.instance.currentUser!.uid == ownerId
                    ? IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showPersistentBottomSheet(context, postId);
                        },
                      )
                    : const SizedBox()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 15, top: 5),
            child: Text(caption, style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 15, top: 5),
            child: Text("Liked by $likes people",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
