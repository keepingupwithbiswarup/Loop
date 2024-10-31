import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/constants/constants.dart';
import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/models/usermodels.dart';

import 'package:loopedin/providers/storage_repository_provider.dart';
import 'package:loopedin/repository/authrepository.dart';
import 'package:loopedin/utils/pickimage.dart';
import 'package:loopedin/utils/showsnackbar.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends ConsumerState<EditProfilePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();
  bool isUserDataLoaded = false;
  File? profilePhotoFile;
  String? downloadUrl;

  Future<void> _loadUserData() async {
    if (isUserDataLoaded) return; // Prevent reloading if already loaded

    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final currUser = await ref
          .read(userNotifierProvider.notifier)
          .fetchUserDataUsingID(
              uid,
              FirebaseFirestore.instance
                  .collection(FirebaseConstants.userCollection));

      if (currUser != null) {
        usernameController.text = currUser.profileName;
        nameController.text = currUser.name;
        bioController.text = currUser.bio;
        setState(() {
          isUserDataLoaded = true;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> newData) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection(FirebaseConstants.userCollection)
          .doc(uid);

      await userRef.update(newData);
      UserSchema? updatedUser = await ref
          .read(userNotifierProvider.notifier)
          .fetchUserDataUsingID(uid, userRef.parent);

      // Notify the provider with the updated user data
      ref.read(userNotifierProvider.notifier).setUser(
          updatedUser!); // Ensure you have a method to convert document to user

      showSnackBar(context: context, text: "Profile updated successfully");
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<bool> isProfileNameUnique(String profileName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirebaseConstants.userCollection)
        .where(
          'profileName',
          isEqualTo: profileName,
        )
        .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Future<void> updateProfile(String? imageUrl) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final isUnique = await isProfileNameUnique(usernameController.text.trim());
    if (!isUnique) {
      showSnackBar(context: context, text: 'Username already exists');
      return;
    }
    if (usernameController.text.startsWith('@')) {
      showSnackBar(context: context, text: 'Username cannot start with @');
      return;
    }
    final newData = {
      'profileName': usernameController.text.trim().toLowerCase(),
      'name': nameController.text.trim(),
      'bio': bioController.text.trim(),
    };

    if (imageUrl != null) {
      newData['profileImage'] = imageUrl;
    }

    await updateUserData(uid, newData);
  }

  void changeProflePhoto() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profilePhotoFile = File(res.files.first.path!);
      });
    }

    if (profilePhotoFile != null) {
      final url = await uploadImage(profilePhotoFile!);
      if (url != null) {
        // After uploading, update the profile data with the new URL
        await updateProfile(url);
      }
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    final storageRepo = ref.read(firebaseStorageProvider);

    try {
      downloadUrl = await storageRepo.storeFile(
        path: 'user_dps',
        id: FirebaseAuth
            .instance.currentUser!.uid, // unique ID for the user or file
        file: imageFile,
      );
      // print('File uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (error) {
      // print('Upload failed: $error');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "Edit profile",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profilePhotoFile != null
                            ? FileImage(profilePhotoFile!)
                            : (user!.profileImage != '')
                                ? NetworkImage(user.profileImage)
                                : const AssetImage(defAvatarPath),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 195,
                      child: GestureDetector(
                        onTap: changeProflePhoto,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: const Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: TextFormField(
                    controller: usernameController,
                    style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                      labelText: 'Username',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 17),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: TextFormField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                      labelText: 'Name',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 17),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: TextFormField(
                    controller: bioController,
                    style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                      labelText: 'Bio',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 17),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(237, 12, 52, 1)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                      ),
                      onPressed: () {
                        print(nameController.text);
                        print(usernameController.text);
                        print(bioController.text);
                        updateProfile(downloadUrl);
                      },
                      child: Text(
                        "Apply Changes",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
