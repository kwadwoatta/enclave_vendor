import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/models/payment.dart';
import 'package:vendor/services/paymentManagement.dart';

class TransactionProvider with ChangeNotifier {
  final paymentManagement = PaymentManagement();
  StreamController<List<Payment>> allPaymentsController = BehaviorSubject();
  StreamController<int> PaymentsLengthController = BehaviorSubject();
  StreamController<int> unviewedPaymentsLengthController = BehaviorSubject();

  StreamController<List<Payment>> spacePaymentsController = BehaviorSubject();
  StreamController<int> spacePaymentsLengthController = BehaviorSubject();

  Stream<List<Payment>> get scoutPayments => allPaymentsController.stream;
  Stream<int> get scoutPaymentsLength => PaymentsLengthController.stream;
  Stream<int> get unviewedPaymentsLength =>
      unviewedPaymentsLengthController.stream;

  Stream<List<Payment>> get spacePayments => spacePaymentsController.stream;
  Stream<int> get spacePaymentsLength => PaymentsLengthController.stream;

//* Retreive all of users's sent Payments and serve as stream
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveScoutPayments() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return paymentManagement.getScoutPayment(user.uid).listen((docList) {
        List<Payment> paymentList = [];

        docList.forEach((snapshot) {
          // PaymentStatus status;
          // switch (snapshot.data['status']) {
          //   case 'pending':
          //     status = PaymentStatus.PENDING;
          //     break;
          //   case 'canceled':
          //     status = PaymentStatus.CANCELED;
          //     break;
          //   case 'rejected':
          //     status = PaymentStatus.REJECTED;
          //     break;
          //   case 'accepted':
          //     status = PaymentStatus.ACCEPTED;
          //     break;
          // }

          final payment = Payment(
            vendorId: snapshot.data['vendorId'],
            vendorName: snapshot.data['vendorName'],
            creationDate: snapshot.data['creationDate'] != null
                ? DateTime.parse(snapshot.data['creationDate'])
                : null,
            eventDate: snapshot.data['eventDate'] != null
                ? DateTime.parse(snapshot.data['eventDate'])
                : null,
            scoutId: snapshot.data['scoutId'],
            scoutName: snapshot.data['scoutName'],
            spaceName: snapshot.data['spaceName'],
            hours: snapshot.data['hours'],
            maxCapacity: snapshot.data['maxCapacity'],
            viewed: snapshot.data['viewed'],
            scoutPhotoUrl: snapshot.data['scoutPhotoUrl'],
          );
          paymentList.add(payment);
        });
        allPaymentsController.add(paymentList);
        PaymentsLengthController.add(paymentList.length);
      });
    }).asStream();
  }

//* Retreive all of vendor's gotten Payments
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveSpacePayments() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return paymentManagement.getReceivedPayment(user.uid).listen((docList) {
        List<Payment> paymentList = [];
        List<Payment> unviewedPaymentList = [];

        docList.forEach((snapshot) {
          // PaymentStatus status;
          // switch (snapshot.data['status']) {
          //   case 'pending':
          //     status = PaymentStatus.PENDING;
          //     break;
          //   case 'canceled':
          //     status = PaymentStatus.CANCELED;
          //     break;
          //   case 'rejected':
          //     status = PaymentStatus.REJECTED;
          //     break;
          //   case 'accepted':
          //     status = PaymentStatus.ACCEPTED;
          //     break;
          // }
          final payment = Payment(
            vendorId: snapshot.data['vendorId'],
            vendorName: snapshot.data['vendorName'],
            creationDate: snapshot.data['creationDate'] != null
                ? DateTime.parse(snapshot.data['creationDate'])
                : null,
            eventDate: snapshot.data['eventDate'] != null
                ? DateTime.parse(snapshot.data['eventDate'])
                : null,
            scoutId: snapshot.data['scoutId'],
            scoutName: snapshot.data['scoutName'],
            spaceName: snapshot.data['spaceName'],
            hours: snapshot.data['hours'],
            maxCapacity: snapshot.data['maxCapacity'],
            viewed: snapshot.data['viewed'],
            scoutPhotoUrl: snapshot.data['scoutPhotoUrl'],
          );
          paymentList.add(payment);
          if (!payment.viewed) unviewedPaymentList.add(payment);
        });
        spacePaymentsController.add(paymentList);
        spacePaymentsLengthController.add(paymentList.length);
        unviewedPaymentsLengthController.add(unviewedPaymentList.length);
      });
    }).asStream();
  }

//* Submit user Payment to database
  Future<void> sendPayment({@required Payment payment}) {
    return paymentManagement.makePayment(payment: payment);
  }

//* Toggle payment view status to true
  Future<void> toggleViewed({@required String paymentId}) {
    return paymentManagement.toggleViewed(id: paymentId);
  }
}
