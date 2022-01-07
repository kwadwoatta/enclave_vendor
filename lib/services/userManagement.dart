import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:vendor/screens/no_connection_screen.dart';
import 'package:vendor/screens/verify_card_screen.dart';
import 'package:vendor/screens/verify_email_screen.dart';
import 'package:vendor/screens/verify_phone_screen.dart';
import 'package:vendor/screens/waiting_connection_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class UserManagement {
//* INITIAL SCREEN AUTHENTICATION
  Widget handleAuth() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        FirebaseUser user = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData)
          return WaitingConnectionScreen();
        else if (snapshot.connectionState == ConnectionState.none)
          return NoConnectionScreen();
        else {
          if (user != null) {
            if (!user.isEmailVerified) return VerifyEmailScreen();

            return StreamBuilder(
              stream: Firestore.instance
                  .collection('vendors')
                  .document(user.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  // if (!snapshot.data['phoneNumberVerified']) {
                  //   return VerifyPhoneScreen();
                  // }
                  // if (snapshot.data['creditCardNumber'] == null) {
                  //   return VerifyCardScreen();
                  // }
                  return HomeScreen();
                } else
                  return LoginScreen();
              },
            );
          } else
            return LoginScreen();
        }
      },
    );
  }

//* GET USER DATA
  Stream<DocumentSnapshot> getUserInfo(String userId) {
    return Firestore.instance
        .collection('vendors')
        .document(userId)
        .snapshots()
        .map((docSnapshot) {
      return docSnapshot;
    });
  }

//* LOGIN FUNCTION
  Future<FirebaseUser> loginUser({
    @required String email,
    @required String password,
  }) async {
    try {
      final HttpsCallable canVendorSignIn = CloudFunctions.instance
          .getHttpsCallable(functionName: 'canVendorSignIn');

      final callResult =
          await canVendorSignIn.call(<String, String>{'email': email});
      if (callResult.data) {
        final response = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = response.user;
        return user;
      } else
        throw Exception(
          'You are not signed up for this app. Try signing up or logging in to the scout app.',
        );
    } catch (error) {
      throw error;
    }
  }

//* LOGIN WITH GOOGLE FUNCTION
  Future<void> logUserInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleSignInAccount = await googleSignIn.signIn();

      final auth = await googleSignInAccount.authentication;

      final result = await FirebaseAuth.instance
          .signInWithCredential(GoogleAuthProvider.getCredential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      ));

      final user = result.user;
      Firestore.instance.runTransaction((transactionHandler) async {
        final userDocRef =
            Firestore.instance.collection('scouts').document(user.uid);

        final userDoc = await transactionHandler.get(userDocRef);
        if (!userDoc.exists)
          await transactionHandler.set(userDocRef, {
            'uid': user.uid,
            'phoneNumber': null,
            'email': user.email,
            'displayName': user.displayName,
            'phoneNumberVerified': false,
            'creditCardNumber': null
          });
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

//* SIGNUP FUNCTION
  Future<String> signupUser({
    @required String userName,
    @required String phoneNumber,
    @required String password,
    @required String email,
    @required File profilePic,
  }) async {
    try {
      final HttpsCallable createVendor = CloudFunctions.instance
          .getHttpsCallable(functionName: 'createVendor');

      final callResult = await createVendor.call({
        'email': email,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'password': password,
      });

      print(callResult.data);
      final userRecord = callResult.data;

      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      FirebaseUser user = result.user;
      final storageRef = FirebaseStorage.instance.ref().child(
            '/profilePics/${user.uid}/${user.uid}.jpg',
          );

      StorageUploadTask task = storageRef.putFile(profilePic);

      StorageTaskSnapshot snapshot = await task.onComplete;
      final url = await snapshot.ref.getDownloadURL();

      final userUpdateInfo = UserUpdateInfo();

      userUpdateInfo.displayName = userName;
      userUpdateInfo.photoUrl = url.toString();

      await user.updateProfile(userUpdateInfo);

      return userRecord['uid'] as String;
    } catch (error) {
      throw error;
    }
  }

  //* RESET FORGOTTEN PASSWORD FUNCTION
  // Future<void> forgottenPasswordReset({
  //   @required String phoneNumber,
  //   @required String newPassword,
  // }) async {
  //   FirebaseAuth.instance.currentUser().then((user) {
  //     // final HttpsCallable isNumberAUser = CloudFunctions.instance
  //     //     .getHttpsCallable(functionName: 'isNumberAUser');

  //     final HttpsCallable resetUserPassword = CloudFunctions.instance
  //         .getHttpsCallable(functionName: 'resetUserPassword');

  //     return user.updatePassword(newPassword).then((_) {
  //       return resetUserPassword.call(<String, String>{
  //         'phoneNumber': phoneNumber,
  //         'password': newPassword,
  //         'displayName': user.displayName,
  //         'uid': user.uid,
  //       }).catchError((e) {
  //         print('*');
  //         print(e);
  //         throw e;
  //       });
  //     });
  //   }).catchError((e) {
  //     print(e.message);
  //     throw e;
  //   });
  // }

//* UPDATE PROFILE PICTURE FUNCTION
  Future<void> updateProfilePic({@required String imageUrl}) async {
    final userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.photoUrl = imageUrl;

    await FirebaseAuth.instance.currentUser().then((user) {
      user.updateProfile(userUpdateInfo).then((_) async {
        final query = await Firestore.instance
            .collection('vendors')
            .where('uid', isEqualTo: user.uid)
            .getDocuments();

        Firestore.instance
            .document('vendors/${query.documents[0].documentID}')
            .updateData({'photoUrl': imageUrl});
      });
    }).catchError((e) {
      print(e);
      throw Exception(e);
    });
  }

//* UPDATE USERNAME FUNCTION
  Future<String> updateDisplayName({
    @required String displayName,
  }) async {
    var updatedName;
    final userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = displayName;

    return await FirebaseAuth.instance.currentUser().then((user) {
      user.updateProfile(userUpdateInfo).then((_) async {
        final query = await Firestore.instance
            .collection('vendors')
            .where('uid', isEqualTo: user.uid)
            .getDocuments();

        Firestore.instance
            .document('vendors/${query.documents[0].documentID}')
            .updateData({'displayName': displayName}).then((_) {
          FirebaseAuth.instance.currentUser().then((user) {
            updatedName = user.displayName;
          });
        });
      });
      return updatedName;
    }).catchError((e) {
      print(e);
    });
  }

//* UPDATE EMAIL
  Future<String> updateEmail({
    @required String email,
    // @required AuthCredential credential,
  }) async {
    return await FirebaseAuth.instance.currentUser().then((user) {
      return user.updateEmail(email).then((_) async {
        final query = await Firestore.instance
            .collection('vendors')
            .where('uid', isEqualTo: user.uid)
            .getDocuments();

        Firestore.instance
            .document('vendors/${query.documents[0].documentID}')
            .updateData({
          'email': email,
        });
      }).catchError((e) {
        print(e);
        throw e;
      });
    }).catchError((e) {
      print(e);
      throw e;
    });
  }

//* VERIFY EMAIL
  Future<void> verifyEmail({
    @required String email,
  }) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      await user.sendEmailVerification();
      await user.reload();
      return email;
    } catch (e) {
      print(e);
      throw e;
    }
  }

//* CREATE SQUARE CUSTOMER
  Future<void> createSquareCustomer({String postalCode, String nonce}) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final saveSquareCustomer = CloudFunctions.instance
          .getHttpsCallable(functionName: 'saveSquareCustomer');

      final response = await saveSquareCustomer.call({
        'vendorId': user.uid,
        'customerName': user.displayName,
        'emailAddress': user.email,
        'phoneNumber': user.phoneNumber,
        'postalCode': postalCode,
        'nonce': nonce,
      });

      return response.data;
    } catch (error) {
      throw error;
    }
  }

//* UPDATE PHONE NUMBER
  Future<String> updatePhoneNumber({
    @required String phoneNumber,
    @required AuthCredential credential,
  }) async {
    try {
      var updatedNumber;
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.updatePhoneNumberCredential(credential);
      await user.reload();

      final qsnapshot = await Firestore.instance
          .collection('vendors')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();

      await Firestore.instance
          .document('vendors/${qsnapshot.documents[0].documentID}')
          .updateData({
        'phoneNumber': phoneNumber,
        'phoneNumberVerified': true,
      });

      user = await FirebaseAuth.instance.currentUser();
      updatedNumber = user.phoneNumber;
      return updatedNumber;
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
