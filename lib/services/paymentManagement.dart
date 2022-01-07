import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vendor/models/payment.dart';

class PaymentManagement {
//*  GET SCOUT TRANSACTIONS
  Stream<List<DocumentSnapshot>> getScoutPayment(String userId) {
    return Firestore.instance
        .collection('payments')
        .where('paymentId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//*  GET VENDOR PAYMENT
  Stream<List<DocumentSnapshot>> getReceivedPayment(String userId) {
    return Firestore.instance
        .collection('payments')
        .where('scoutId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//* ADD TRANSACTION
  Future<void> makePayment({
    @required Payment payment,
  }) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();

      DocumentReference paymentDocRef =
          Firestore.instance.collection('/payments').document();

      Map<String, dynamic> newPayment = {
        'paymentId': paymentDocRef.documentID,
        'spaceName': payment.spaceName,
        'eventDate': payment.eventDate.toIso8601String(),
        'creationDate': payment.creationDate.toIso8601String(),
        'scoutId': user.uid,
        'scoutName': user.displayName,
        'maxCapacity': payment.maxCapacity,
        'hours': payment.hours,
        'vendorId': payment.vendorId,
        'vendorName': payment.vendorName,
        'viewed': payment.viewed,
        'scoutPhotoUrl': user.photoUrl,
        'vendorPhotoUrl': payment.vendorPhotoUrl,
      };

      return Firestore.instance.runTransaction((transactionHandler) async {
        await transactionHandler.set(paymentDocRef, newPayment);
        await transactionHandler.update(paymentDocRef, {});
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Toggle request view
  Future<void> toggleViewed({@required String id}) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/payments').document(id);

      return docRef.updateData({'viewed': true});
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
