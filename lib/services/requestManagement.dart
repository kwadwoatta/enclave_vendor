import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:vendor/models/request.dart';

class RequestManagement {
//*  GET USER REQUESTS
  Stream<List<DocumentSnapshot>> getReceivedRequests(String userId) {
    return Firestore.instance
        .collection('requests')
        .where('vendorId', isEqualTo: userId)
        .snapshots()
        .map((qSnapshot) {
      return qSnapshot.documents;
    });
  }

//* ADD request
  Future<void> postRequest({
    @required Request request,
  }) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();

      DocumentReference docRef =
          Firestore.instance.collection('/requests').document();

      String status;
      switch (request.status) {
        case RequestStatus.PENDING:
          status = 'pending';
          break;
        case RequestStatus.CANCELED:
          status = 'canceled';
          break;
        case RequestStatus.REJECTED:
          status = 'rejected';
          break;
        case RequestStatus.ACCEPTED:
          status = 'accepted';
          break;
      }

      Map<String, dynamic> newrequest = {
        'requestId': docRef.documentID,
        'spaceName': request.spaceName,
        'eventDate': request.eventDate.toIso8601String(),
        'creationDate': request.creationDate.toIso8601String(),
        'cancelationDate': null,
        'rejectionDate': null,
        'acceptanceDate': null,
        'scoutId': user.uid,
        'scoutName': user.displayName,
        'maxCapacity': request.maxCapacity,
        'hours': request.hours,
        'vendorId': request.vendorId,
        'vendorName': request.vendorName,
        'status': status,
        'viewedByVendor': request.viewedByVendor,
        'viewedByScout': request.viewedByScout,
        'scoutPhotoUrl': user.photoUrl,
        'spaceImages': request.spaceImages,
        'vendorPhotoUrl': request.vendorPhotoUrl,
        'pricePerHour': request.pricePerHour,
      };
      return docRef.setData(newrequest);
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Toggle request view
  Future<void> toggleViewed({
    @required String id,
  }) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/requests').document(id);

      return docRef.updateData({'viewedByVendor': true});
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Accept request
  Future<void> acceptRequest({
    @required String id,
  }) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/requests').document(id);

      return docRef.updateData({
        'acceptanceDate': DateTime.now().toIso8601String(),
        'status': 'accepted'
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Decline request
  Future<void> declineRequest({
    @required String id,
  }) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/requests').document(id);

      return docRef.updateData({
        'rejectionDate': DateTime.now().toIso8601String(),
        'status': 'rejected'
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

//* Cancel request
  Future<void> cancelRequest({
    @required String id,
  }) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection('/requests').document(id);

      return docRef.updateData({
        'cancelationDate': DateTime.now().toIso8601String(),
        'status': 'canceled',
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
