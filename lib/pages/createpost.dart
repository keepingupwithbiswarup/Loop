import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/providers/storage_repository_provider.dart';
import 'package:loopedin/utils/pickimage.dart';
import 'package:loopedin/utils/showsnackbar.dart';
import 'package:loopedin/utils/video.dart';
import 'package:uuid/uuid.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() => CreatePostPageState();
}

class CreatePostPageState extends ConsumerState<CreatePostPage> {
  File? postFile;
  String? downloadUrl;
  final TextEditingController captionController = TextEditingController();

  Future<String?> uploadMedia(File postFile) async {
    final storageRepo = ref.read(firebaseStorageProvider);

    try {
      downloadUrl = await storageRepo.storeFile(
        path: 'all_posts',
        id: const Uuid().v4(),
        file: postFile,
      );
      print('File uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (error) {
      print('Upload failed: $error');
    }
    return null;
  }

  Future<void> createPost() async {
    if (postFile == null) {
      return;
    }
    try {
      final url = await uploadMedia(postFile!);
      if (url == null) {
        throw "No url found";
      }
      final customId = const Uuid().v4();
      FirebaseFirestore.instance
          .collection(FirebaseConstants.postCollection)
          .doc(customId)
          .set({
        'postId': customId,
        'postUrl': url,
        'caption': captionController.text.trim(),
        'ownerId': FirebaseAuth.instance.currentUser!.uid,
        'likes': [],
        'timestamp': Timestamp.now(),
      });
      showSnackBar(context: context, text: 'Post added successfully');
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context: context, text: 'Some error occurred');
    }
  }

  void selectPost() async {
    try {
      final post = await pickPost();
      if (post != null) {
        setState(() {
          postFile = File(post.files.first.path!);
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, text: "Some error occurred");
    }
  }

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
          "Create Post",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Center(
              child: Column(
                children: [
                  DottedBorder(
                    color: const Color.fromARGB(255, 122, 122, 122),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    radius: const Radius.circular(12),
                    strokeWidth: 1.5,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: GestureDetector(
                        onTap: selectPost,
                        child: Container(
                          width: double.infinity,
                          height: 350,
                          decoration: const BoxDecoration(),
                          child: postFile != null
                              ? postFile!.path.endsWith('.mp4')
                                  ? LoopingVideoPlayer(videoFile: postFile!)
                                  : Image.file(postFile!)
                              : const Icon(
                                  Icons.camera_alt,
                                  size: 60,
                                  color: Color.fromARGB(255, 122, 122, 122),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: null,
                      controller: captionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write a caption...',
                        hintStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ElevatedButton(
          style: const ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
              backgroundColor:
                  WidgetStatePropertyAll(Color.fromRGBO(237, 12, 52, 1))),
          onPressed: () {
            createPost();
          },
          child: Text(
            "Share",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        ),
      ),
    );
  }
}
