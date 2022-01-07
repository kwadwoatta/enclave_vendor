import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/widgets/showAlertDialog.dart';
import 'package:vendor/widgets/show_alert_dialog.dart';
import 'package:vendor/widgets/show_error_dialog.dart';

import '../services/userManagement.dart';
import '../models/vendor.dart';

class UserProvider with ChangeNotifier {
  String verificationId;
  final userManagement = UserManagement();
  StreamController<Vendor> userInfoController = BehaviorSubject();

  Stream<Vendor> get user => userInfoController.stream;

  //* Retreive all of vendor's spaces and serve as stream
  // Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveUserSpaces() {
  Future<void> retreiveUserSpaces() async {
    if (await user.isEmpty)
      return FirebaseAuth.instance.currentUser().then((user) {
        return userManagement.getUserInfo(user.uid).listen((snapshot) {
          final vendor = Vendor(
            name: snapshot.data['displayName'],
            email: snapshot.data['email'],
            phoneNumber: snapshot.data['phoneNumber'],
            vendorID: snapshot.data['uid'],
            card: snapshot.data['cardId'],
            // receipts: snapshot.data['receipts'],
            // vendingSpaces: snapshot.data['vendingSpaces'],
            // photoUrl: snapshot.data['photoUrl'],
            // favoritesIDs: snapshot.data['favoriteSpaces'],
          );
          userInfoController.add(vendor);
        });
      }).asStream();
  }

  //* log user in
  Future<void> logUserIn({
    @required String email,
    @required String password,
  }) {
    return userManagement.loginUser(
      email: email,
      password: password,
    );
  }

  Future<void> logUserInWithGoogle() {
    return userManagement.logUserInWithGoogle();
  }

  //* send opt manually
  Future<void> manualSendOPT({
    @required BuildContext context,
    @required String phoneNumber,
  }) {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (verId) {
      verificationId = verId;
      notifyListeners();
      print('autoretreival timed out');
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;

      showAlertDialog(
        context: context,
        type: "success",
        message: "We've sent you an SMS code. Please enter it below",
      );
      notifyListeners();
    };

    final PhoneVerificationCompleted verifySucceed = (AuthCredential authCred) {
      ShowAlertDialog(
          context: context, actionable: false, message: "Verifying ...");
      Navigator.of(context).pushReplacementNamed('/verify-card');
    };

    final PhoneVerificationFailed verifyFailed = (AuthException authEx) {
      throw Exception(authEx.message);
    };

    return FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: "+2330$phoneNumber",
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 30),
      verificationFailed: verifyFailed,
      verificationCompleted: verifySucceed,
    )
        .catchError((error) {
      print(error);
      ErrorDialog(context: context, error: error);

      throw Exception(error);
    });
  }

  //* sign user up
  Future<void> signUserUp({
    @required String userName,
    @required String phoneNumber,
    @required String password,
    @required String email,
    @required File profilePic,
  }) {
    return userManagement.signupUser(
      email: email,
      userName: userName,
      phoneNumber: phoneNumber,
      password: password,
      profilePic: profilePic,
    );
  }

  //* update user profile picture
  Future<void> updateProfilePic({@required String imageUrl}) {
    return userManagement.updateProfilePic(imageUrl: imageUrl);
  }

  //* update user's name
  Future<void> updateDisplayName({@required String displayName}) {
    return userManagement.updateDisplayName(displayName: displayName);
  }

  //* update user's phone number
  Future<void> updatePhoneNumber({
    @required String phoneNumber,
    @required AuthCredential credential,
  }) {
    try {
      return userManagement.updatePhoneNumber(
        phoneNumber: phoneNumber,
        credential: credential,
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //* update user's email
  Future<void> updateEmail({
    @required String email,
  }) {
    print('In user update email');
    print(email);
    return userManagement.updateEmail(email: email);
  }

  //* verify user's email
  Future<void> verifyEmail({
    @required String email,
  }) {
    return userManagement.verifyEmail(email: email);
  }

  //* make user a square customer
  Future<void> createSquareCustomer({String postalCode, String nonce}) {
    return userManagement.createSquareCustomer(
      postalCode: postalCode,
      nonce: nonce,
    );
  }

  //* update user's profile picture
  Future<void> uploadPicFunc({@required File picture}) async {
    String storageUrl;
    final user = await FirebaseAuth.instance.currentUser();
    final storageReference =
        FirebaseStorage.instance.ref().child('profilePics/${user.uid}.jpg');
    final task = storageReference.putFile(picture);

    return task.onComplete.then((taskSnapshot) async {
      final url = await taskSnapshot.ref.getDownloadURL();
      storageUrl = url.toString();
      return userManagement.updateProfilePic(
        imageUrl: storageUrl,
      );
    }).catchError((e) {
      print(e);
      throw Exception(e);
    });
  }
}
