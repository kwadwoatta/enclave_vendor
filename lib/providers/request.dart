import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/models/request.dart';
import 'package:vendor/services/requestManagement.dart';

class RequestProvider with ChangeNotifier {
  final requestManagement = RequestManagement();
  StreamController<int> unviewedRequestsLengthController = BehaviorSubject();

  StreamController<List<Request>> spaceRequestsController = BehaviorSubject();
  StreamController<int> spaceRequestsLengthController = BehaviorSubject();

  Stream<int> get unviewedRequestsLength =>
      unviewedRequestsLengthController.stream;

  Stream<List<Request>> get spaceRequests => spaceRequestsController.stream;
  Stream<int> get spaceRequestsLength => spaceRequestsLengthController.stream;

//* Retreive all of vendor's gotten requests
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveSpaceRequests() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return requestManagement.getReceivedRequests(user.uid).listen((docList) {
        List<Request> requestList = [];
        List<Request> unviewedRequestList = [];

        docList.forEach((snapshot) {
          RequestStatus status;
          switch (snapshot.data['status']) {
            case 'pending':
              status = RequestStatus.PENDING;
              break;
            case 'canceled':
              status = RequestStatus.CANCELED;
              break;
            case 'rejected':
              status = RequestStatus.REJECTED;
              break;
            case 'accepted':
              status = RequestStatus.ACCEPTED;
              break;
          }
          final request = Request(
            vendorId: snapshot.data['vendorId'],
            vendorName: snapshot.data['vendorName'],
            acceptanceDate: snapshot.data['acceptanceDate'] != null
                ? DateTime.parse(snapshot.data['acceptanceDate'])
                : null,
            cancelationDate: snapshot.data['cancelationDate'] != null
                ? DateTime.parse(snapshot.data['cancelationDate'])
                : null,
            creationDate: snapshot.data['creationDate'] != null
                ? DateTime.parse(snapshot.data['creationDate'])
                : null,
            eventDate: snapshot.data['eventDate'] != null
                ? DateTime.parse(snapshot.data['eventDate'])
                : null,
            rejectionDate: snapshot.data['rejectionDate'] != null
                ? DateTime.parse(snapshot.data['rejectionDate'])
                : null,
            requestId: snapshot.data['requestId'],
            scoutId: snapshot.data['scoutId'],
            scoutName: snapshot.data['scoutName'],
            spaceName: snapshot.data['spaceName'],
            status: status,
            hours: snapshot.data['hours'],
            maxCapacity: snapshot.data['maxCapacity'],
            viewedByScout: snapshot.data['viewedByScout'],
            viewedByVendor: snapshot.data['viewedByVendor'],
            scoutPhotoUrl: snapshot.data['scoutPhotoUrl'],
            vendorPhotoUrl: snapshot.data['vendorPhotoUrl'],
            pricePerHour: snapshot.data['pricePerHour'],
            spaceImages: List<String>.from([...snapshot.data['spaceImages']]),
          );
          requestList.add(request);
          if (!request.viewedByVendor) unviewedRequestList.add(request);
        });
        spaceRequestsController.add(requestList);
        spaceRequestsLengthController.add(requestList.length);
        unviewedRequestsLengthController.add(unviewedRequestList.length);
      });
    }).asStream();
  }

//* Submit user request to database
  Future<void> sendRequest({@required Request request}) {
    return requestManagement.postRequest(request: request);
  }

//* Toggle request view status to true
  Future<void> toggleViewed({@required String requestId}) {
    return requestManagement.toggleViewed(id: requestId);
  }

//* Accept request
  Future<void> acceptRequest({@required String requestId}) {
    return requestManagement.acceptRequest(id: requestId);
  }

//* Decline request
  Future<void> declineRequest({@required String requestId}) {
    return requestManagement.declineRequest(id: requestId);
  }

//* Cancel request
  Future<void> cancelRequest({@required String requestId}) {
    return requestManagement.cancelRequest(id: requestId);
  }
}
