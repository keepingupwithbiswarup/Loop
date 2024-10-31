import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loopedin/constants/firebaseconstants.dart';
import 'package:loopedin/models/usermodels.dart';
import 'package:loopedin/pages/loginpage.dart';
import 'package:loopedin/providers/firebaseproviders.dart';
import 'package:loopedin/utils/showsnackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends StateNotifier<UserSchema?> {
  UserNotifier() : super(null);

  Future<void> updateUser(UserSchema? userSchema) async {
    state = userSchema;
  }

  void setUser(UserSchema user) {
    state = user; // Update the user state
  }

  Future<UserSchema?> fetchUserData(
      FirebaseAuth auth, CollectionReference users) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final userDoc = await users.doc(user.uid).get();

        // Ensure the document exists and contains data
        if (userDoc.exists && userDoc.data() != null) {
          final userData =
              UserSchema.fromMap(userDoc.data() as Map<String, dynamic>);

          // Update the state
          state = userData;

          return state; // Return the updated state
        } else {
          print('User document does not exist.');
        }
      } else {
        print('No authenticated user found.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    return null; // Return null if any of the above conditions fail
  }

  Future<UserSchema?> fetchUserDataUsingID(
      String uid, CollectionReference users) async {
    try {
      final userDoc = await users.doc(uid).get();

      // Ensure the document exists and contains data
      if (userDoc.exists && userDoc.data() != null) {
        final userData =
            UserSchema.fromMap(userDoc.data() as Map<String, dynamic>);

        // Update the state
        state = userData;

        return state; // Return the updated state
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    return null; // Return null if any of the above conditions fail
  }
}

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserSchema?>((ref) {
  return UserNotifier();
});

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
      auth: ref.read(firebaseAuthProvider),
      googleSignIn: ref.read(googleSignInProvider),
      firestore: ref.read(firestoreProvider));
});

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);

  Future<bool> isProfileNameUnique(String profileName) async {
    final querySnapshot =
        await _users.where('profileName', isEqualTo: profileName).get();

    return querySnapshot.docs.isEmpty;
  }

  Future<bool> signInWithGoogle(WidgetRef ref) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (_auth.currentUser != null) {
        return true;
      }

      if (googleUser == null) {
        // User canceled the sign-in process
        return false;
      }

      ref.read(isLoadingProvider.notifier).state = true;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        // UserCredential's user property is null
        return false;
      }

      final phoneNumber = user.phoneNumber ?? '';
      final countryCode =
          phoneNumber.isNotEmpty ? phoneNumber.substring(0, 2) : '';
      final contactNumber =
          phoneNumber.isNotEmpty ? phoneNumber.substring(3) : '';

      final userDoc = await _users.doc(user.uid).get();
      if (userDoc.exists) {
        final userData = await getUserData(user.uid).first;
        print(userData);
        if (ref.read(userNotifierProvider.notifier).mounted) {
          ref.read(userNotifierProvider.notifier).updateUser(userData);
        }
      } else {
        final userSchema = UserSchema(
          userId: user.uid,
          name: user.displayName ?? 'Unknown',
          profileName: user.uid,
          email: user.email ?? 'Unknown',
          password: '',
          dob: '',
          profileImage: user.photoURL ?? '',
          backgroundImage: '',
          gender: '',
          date: DateTime.now(),
          countryCode: countryCode,
          contactNumber: contactNumber,
          followers: 0,
          following: 0,
          bio: '',
        );

        await _users.doc(user.uid).set(userSchema.toMap());
        if (ref.read(userNotifierProvider.notifier).mounted) {
          ref.read(userNotifierProvider.notifier).updateUser(userSchema);
        }
      }

      return true;
    } catch (e) {
      // Replace print with a more sophisticated logging mechanism
      print('Error signing in with Google: $e');
      return false;
    }
  }

  Future<void> signOutWithGoogle(WidgetRef ref) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      ref.read(userNotifierProvider.notifier).updateUser(null);
    } catch (e) {
      // Replace print with a more sophisticated logging mechanism
      print('Error signing out with Google: $e');
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String username,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    ref.read(isLoadingProvider.notifier).state = true;
    try {
      final isUnique = await isProfileNameUnique(username);
      if (!isUnique) {
        showSnackBar(context: context, text: 'Username already exists');
        return false;
      }
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final userSchema = UserSchema(
          userId: userCredential.user!.uid,
          name: name,
          profileName: username,
          email: email,
          password: password,
          dob: '',
          profileImage: '',
          backgroundImage: '',
          gender: '',
          date: DateTime.now(),
          countryCode: '',
          contactNumber: '',
          followers: 0,
          following: 0,
          bio: '',
        );
        await _users.doc(userCredential.user!.uid).set(userSchema.toMap());
        ref.read(userNotifierProvider.notifier).updateUser(userSchema);

        var prefs = await SharedPreferences.getInstance();
        ref.read(isLoggedInProvider.notifier).state = true;
        prefs.setBool('LoggedIn', ref.read(isLoggedInProvider.notifier).state);
        prefs.setString("UID", userCredential.user!.uid);

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      showSnackBar(context: context, text: e.message!);
      return false;
    } catch (e) {
      // Handle any other exceptions and show a generic snackbar
      showSnackBar(context: context, text: 'An unexpected error occurred');
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      ref.read(isLoadingProvider.notifier).state = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ref.read(userNotifierProvider.notifier).fetchUserData(_auth, _users);
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, text: e.message!);
      return false;
    } catch (e) {
      showSnackBar(context: context, text: 'An unexpected error occurred');
      return false;
    }
  }

  Future<bool> resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, text: e.message!);
      return false;
    } catch (e) {
      showSnackBar(context: context, text: 'An unexpected error occurred');
      return false;
    }
  }

  Stream<UserSchema> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserSchema.fromMap(event.data() as Map<String, dynamic>));
  }
}
