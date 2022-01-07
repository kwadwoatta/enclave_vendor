// static List<String> images = [
//     'https://pbs.twimg.com/media/EE9sDOiWkAAc0qn.jpg',
//     'https://pbs.twimg.com/media/EFy1jGkWoAEwhav.jpg',
//     'https://pbs.twimg.com/media/D-tFLafXYAAumg4.jpg',
//     'https://pbs.twimg.com/media/D-tFLacXkAMGR3E.jpg',
//     'https://culartblog.files.wordpress.com/2015/08/poets1.jpg',
//     'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//   ];

// List<Event> _events = [
//   Event(
//     advertistmentId: UniqueKey().toString(),
//     advertiserId: UniqueKey().toString(),
//     // date: DateTime.now(),
//     adName: 'Seriously Dwoking with Dwomoh',
//     price: 20.00,
//     description: 'Stand up comedy with Dwomoh',
//     coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//     flyers: images,
//     phoneNumber: '0500000000',
//   ),
//   Event(
//     advertistmentId: UniqueKey().toString(),
//     advertiserId: UniqueKey().toString(),
//     // date: DateTime.now(),
//     adName: 'Seriously Dwoking with Dwomoh',
//     price: 20.00,
//     description: 'Stand up comedy with Dwomoh',
//     coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//     flyers: images,
//     phoneNumber: '0500000000',
//   ),
//   Event(
//     advertistmentId: UniqueKey().toString(),
//     advertiserId: UniqueKey().toString(),
//     // date: DateTime.now(),
//     adName: 'Seriously Dwoking with Dwomoh',
//     price: 20.00,
//     description: 'Stand up comedy with Dwomoh',
//     coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//     flyers: images,
//     phoneNumber: '0500000000',
//   ),
//   Event(
//     advertistmentId: UniqueKey().toString(),
//     advertiserId: UniqueKey().toString(),
//     // date: DateTime.now(),
//     adName: 'Seriously Dwoking with Dwomoh',
//     price: 20.00,
//     description: 'Stand up comedy with Dwomoh',
//     coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//     flyers: images,
//     phoneNumber: '0500000000',
//   ),
//   Event(
//     advertistmentId: UniqueKey().toString(),
//     advertiserId: UniqueKey().toString(),
//     // date: DateTime.now(),
//     adName: 'Seriously Dwoking with Dwomoh',
//     price: 20.00,
//     description: 'Stand up comedy with Dwomoh',
//     coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//     flyers: images,
//     phoneNumber: '0500000000',
//   ),
//   Event(
//     advertistmentId: UniqueKey().toString(),
//     advertiserId: UniqueKey().toString(),
//     // date: DateTime.now(),
//     adName: 'Seriously Dwoking with Dwomoh',
//     price: 20.00,
//     description: 'Stand up comedy with Dwomoh',
//     coverPhoto: 'https://pbs.twimg.com/media/CM1vf_YXAAAbdL0.jpg',
//     flyers: images,
//     phoneNumber: '0500000000',
//   ),
// ];
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vendor/models/event.dart';
import 'package:vendor/services/eventManagement.dart';

class EventProvider with ChangeNotifier {
  final eventManagement = EventManagement();

  //* StreamController for all of listed events
  StreamController<List<Event>> allEventsController = BehaviorSubject();

  //* StreamController for all of listed events
  StreamController<List<String>> allEventsCoverPhotoController =
      BehaviorSubject();

  //* StreamController for all of vendor's events
  StreamController<List<Event>> vendorEventsController = BehaviorSubject();

  //* StreamController for filtered events
  StreamController<List<Event>> filteredEventsController = BehaviorSubject();

  //* StreamController for searched events
  StreamController<List<Event>> searchedEventsController = BehaviorSubject();

  //* StreamController for length of all events
  StreamController<int> eventsLengthController = BehaviorSubject();

  //* StreamController for length of filtered events
  StreamController<int> filteredEventsLengthController = BehaviorSubject();

  //* StreamController for length of searched events
  StreamController<int> searchedEventsLengthController = BehaviorSubject();

  Stream<List<Event>> get myevents => vendorEventsController.stream;
  Stream<List<String>> get allEventsCoverPhotos =>
      allEventsCoverPhotoController.stream;
  Stream<List<Event>> get events => allEventsController.stream;
  Stream<List<Event>> get filteredEvents => filteredEventsController.stream;
  Stream<List<Event>> get searchedEvents => searchedEventsController.stream;
  Stream<int> get eventsLength => eventsLengthController.stream;
  Stream<int> get filteredEventsLength => filteredEventsLengthController.stream;
  Stream<int> get searchedEventsLength => searchedEventsLengthController.stream;

//* Retreive all of vendor's events and serve as stream
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveUserevents() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return eventManagement.getVendorEvents(user.uid).listen((docList) {
        List<Event> eventList = [];

        docList.forEach((snapshot) {
          var event = Event(
            adName: snapshot.data['eventName'],
            address: snapshot.data['address'],
            city: snapshot.data['city'],
            price: snapshot.data['price'],
            advertiserId: snapshot.data['advertiserId'],
            advertistmentId: snapshot.data['advertistmentId'],
            coverPhoto: snapshot.data['coverPhoto'],
            creationDate: snapshot.data['creationDate'],
            description: snapshot.data['description'],
            eventDate: snapshot.data['eventDate'],
            flyers: List<String>.from([...snapshot.data['flyers']]),
            isFavorite: snapshot.data['isFavorite'],
            phoneNumber: snapshot.data['phoneNumber'],
          );
          eventList.add(event);
        });
        vendorEventsController.add(eventList);
      });
    }).asStream();
  }

//* Retreive all available events and serve as stream
  Stream<StreamSubscription<List<DocumentSnapshot>>> retreiveAllevents() {
    return FirebaseAuth.instance.currentUser().then((user) {
      return eventManagement.getAllEvents(user.uid).listen((docList) {
        List<Event> eventList = [];
        List<String> allEventsCoverPhotos = [];
        docList.forEach((snapshot) {
          var event = Event(
            adName: snapshot.data['eventName'],
            address: snapshot.data['address'],
            city: snapshot.data['city'],
            price: snapshot.data['price'],
            advertiserId: snapshot.data['advertiserId'],
            advertistmentId: snapshot.data['advertistmentId'],
            coverPhoto: snapshot.data['coverPhoto'],
            description: snapshot.data['description'],
            creationDate: snapshot.data['creationDate'] != null
                ? DateTime.parse(snapshot.data['creationDate'])
                : null,
            eventDate: snapshot.data['eventDate'] != null
                ? DateTime.parse(snapshot.data['eventDate'])
                : null,
            flyers: List<String>.from([...snapshot.data['flyers']]),
            isFavorite: snapshot.data['isFavorite'],
            phoneNumber: snapshot.data['phoneNumber'],
          );
          eventList.add(event);
          allEventsCoverPhotos.add(event.coverPhoto);
        });
        allEventsController.add(eventList);
        eventsLengthController.add(eventList.length);
        allEventsCoverPhotoController.add(allEventsCoverPhotos);
      });
    }).asStream();
  }

//* Filter events
  void filterEvents({
    date,
    city = 'Accra',
  }) {
    filteredEventsController = BehaviorSubject();
    filteredEventsLengthController = BehaviorSubject();

    // events.listen((allevents) {
    //   List<Event> filtered = [];
    //   allevents.forEach((event) {
    //     if (event.city == city &&
    //         event.minCapacity >= minCap &&
    //         event.maxCapacity <= maxCap) filtered.add(event);
    //   });
    //   filteredEventsController.add(filtered);
    //   filteredEventsLengthController.add(filtered.length);
    // });
  }

//* Search event
  void searchEvents({
    String name,
  }) {
    searchedEventsController = BehaviorSubject();
    searchedEventsLengthController = BehaviorSubject();

    events.listen((allevents) {
      List<Event> searched = [];
      allevents.forEach((event) {
        if (event.adName.toLowerCase() == name.toLowerCase())
          searched.add(event);
      });
      searchedEventsController.add(searched);
      searchedEventsLengthController.add(searched.length);
    });
  }

//* Upload vendor event to database
  Future<void> uploadevent({
    @required Event event,
    @required List<File> imageFiles,
  }) {
    return eventManagement.postEvent(
      event: event,
      imageFiles: imageFiles,
    );
  }

  //* List<event> geteventByCity({String cityName}) {
  //*   return _events.where((event) {
  //*     return event.city == cityName;
  //*   });
  //* }
}
