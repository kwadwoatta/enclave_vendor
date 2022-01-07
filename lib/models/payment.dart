import 'package:flutter/cupertino.dart';
import 'package:vendor/models/receipt.dart';

enum PaymentMethod { MTN, VODAFONE, TIGO, AIRTEL, ATM }

class Payment {
  final String paymentId;
  final String scoutId;
  final String scoutName;
  final String vendorId;
  final String vendorName;
  final String spaceName;
  final DateTime eventDate;
  final DateTime creationDate;
  final int hours;
  final int maxCapacity;
  bool viewed;
  final String scoutPhotoUrl;
  final String vendorPhotoUrl;
  final PaymentMethod method;
  final double pricePerHour;
  double bookingFee;
  double bookProcessingFee;
  double scoutTotal;
  double appFee;
  double appProcessingFee;
  double vendorTotalReceived;

  Payment({
    @required this.paymentId,
    @required this.spaceName,
    @required this.eventDate,
    @required this.creationDate,
    @required this.scoutId,
    @required this.scoutName,
    @required this.vendorId,
    @required this.vendorName,
    @required this.hours,
    @required this.maxCapacity,
    @required this.scoutPhotoUrl,
    @required this.vendorPhotoUrl,
    @required this.method,
    @required this.pricePerHour,
    this.viewed = false,
  }) {
    bookingFee = pricePerHour * hours;
    bookProcessingFee = bookingFee * .01;
    scoutTotal = bookingFee + bookProcessingFee;
    appFee = bookingFee * .05;
    appProcessingFee = appFee * .01;
    vendorTotalReceived = bookingFee - appFee - appProcessingFee;
  }

  var m = {
    "payment": {
      "id": "iqrBxAil6rmDtr7cak9g9WO8uaB",
      "created_at": "2019-07-10T13:23:49.154Z",
      "updated_at": "2019-07-10T13:23:49.446Z",
      "amount_money": {"amount": 200, "currency": "USD"},
      "app_fee_money": {"amount": 10, "currency": "USD"},
      "total_money": {"amount": 200, "currency": "USD"},
      "status": "COMPLETED",
      "source_type": "CARD",
      "card_details": {
        "status": "CAPTURED",
        "card": {
          "card_brand": "VISA",
          "last_4": "2796",
          "exp_month": 7,
          "exp_year": 2026,
          "fingerprint":
              "sq-1-TpmjbNBMFdibiIjpQI5LiRgNUBC7u1689i0TgHjnlyHEWYB7tnn-K4QbW4ttvtaqXw"
        },
        "entry_method": "ON_FILE",
        "cvv_status": "CVV_ACCEPTED",
        "avs_status": "AVS_ACCEPTED",
        "auth_result_code": "nsAyY2"
      },
      "location_id": "XK3DBG77NJBFX",
      "order_id": "qHkNOb03hMgEgoP3gyzFBDY3cg4F",
      "reference_id": "123456",
      "note": "Brief description",
      "customer_id": "VDKXEEKPJN48QDG3BGGFAK05P8"
    }
  };
}
