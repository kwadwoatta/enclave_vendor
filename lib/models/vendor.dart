import 'package:flutter/foundation.dart';
import 'package:square_in_app_payments/models.dart';

import '../models/receipt.dart';
import '../models/space.dart';

class Vendor {
  String vendorID;
  String name;
  String phoneNumber;
  String email;
  String photoUrl;
  List<Space> vendingSpaces;
  List<Receipt> receipts;
  Card card;
  List<String> favoritesIDs;

  Vendor({
    @required this.vendorID,
    @required this.name,
    @required this.phoneNumber,
    @required this.photoUrl,
    @required this.email,
    this.favoritesIDs,
    this.vendingSpaces,
    this.receipts,
    this.card,
  });
}
