import 'package:flutter/material.dart';

import 'package:vendor/screens/about_screen.dart';
import 'package:vendor/screens/add_credit_card_screen.dart';
import 'package:vendor/screens/add_event_screen.dart';
import 'package:vendor/screens/add_space_screen.dart';
import 'package:vendor/screens/complete_space_payment_screen.dart';
import 'package:vendor/screens/confirm_ad_form_screen.dart';
import 'package:vendor/screens/confirm_space_form_screen.dart';
import 'package:vendor/screens/no_connection_screen.dart';
import 'package:vendor/screens/payments_screen.dart';
import 'package:vendor/screens/requests_screen.dart';
import 'package:vendor/screens/search_spaces_screen.dart';
import 'package:vendor/screens/space_details_screen.dart';
import 'package:vendor/screens/waiting_connection_screen.dart';
import '../screens/ad_details_screen.dart';
import '../screens/city_spaces_screen.dart';
import '../screens/events_screen.dart';
import '../screens/my_spaces_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  SignupScreen.routeName: (context) => SignupScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MySpacesScreen.routeName: (context) => MySpacesScreen(),
  EventsScreen.routeName: (context) => EventsScreen(),
  SettingsScreen.routeName: (context) => SettingsScreen(),
  CitySpacesScreen.routeName: (context) => CitySpacesScreen(),
  AdDetailScreen.routeName: (context) => AdDetailScreen(),
  SearchSpacesScreen.routeName: (context) => SearchSpacesScreen(),
  AddSpaceScreen.routeName: (context) => AddSpaceScreen(),
  AddEventScreen.routeName: (context) => AddEventScreen(),
  AboutScreen.routeName: (context) => AboutScreen(),
  ConfirmSpaceFormScreen.routeName: (context) => ConfirmSpaceFormScreen(),
  ConfirmAdFormScreen.routeName: (context) => ConfirmAdFormScreen(),
  SpaceDetailsScreen.routeName: (context) => SpaceDetailsScreen(),
  RequestsScreen.routeName: (context) => RequestsScreen(),
  WaitingConnectionScreen.routeName: (context) => WaitingConnectionScreen(),
  NoConnectionScreen.routeName: (context) => NoConnectionScreen(),
  PaymentsScreen.routeName: (context) => PaymentsScreen(),
  CompleteSpacePaymentScreen.routeName: (context) =>
      CompleteSpacePaymentScreen(),
  AddCreditCardScreen.routeName: (context) => AddCreditCardScreen(),
};
