import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class CreditCardInputScreen extends StatefulWidget {
  static const routeName = 'credit-card-input';
  @override
  _CreditCardInputScreenState createState() => _CreditCardInputScreenState();
}

class _CreditCardInputScreenState extends State<CreditCardInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: CreditCardWidget(),
          ),
          Expanded(
            flex: 6,
            child: Form(),
          ),
        ],
      ),
    );
  }
}
