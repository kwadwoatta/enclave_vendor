import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:vendor/custom_icons/custom_icons.dart';

class AddCreditCardScreen extends StatefulWidget {
  static const routeName = "/add-credit-card";
  @override
  _AddCreditCardScreenState createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  bool _isInit = true;
  bool cvvFocused = false;
  bool isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cvvCode = TextEditingController();
  TextEditingController expiryDate = TextEditingController();

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await FirebaseAuth.instance.currentUser().then((user) {
        setState(() {
          cardHolderName = TextEditingController(text: user.displayName);
        });
      }).catchError((e) {
        print(e);
      });

      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            height: height * .35,
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * .01,
              vertical: height * .01,
            ),
            child: CreditCardWidget(
              cardNumber: cardNumber.text,
              cardHolderName: cardHolderName.text,
              cvvCode: cvvCode.text,
              expiryDate: expiryDate.text,
              showBackView: cvvFocused,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width * .05,
                          vertical: height * .03,
                        ),
                        height: height * .08,
                        child: TextFormField(
                          onChanged: (val) => setState(() => () {}),
                          cursorColor: primaryColor,
                          readOnly: isLoading,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 20, color: primaryColor),
                          controller: cardNumber,
                          // validator: (val) => _phoneValidator(val),
                          decoration: InputDecoration(
                            prefixIcon: Icon(CustomIcons.phone),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accentColor),
                            ),
                            labelText: 'Card Number',
                            labelStyle: TextStyle(
                              fontSize: 15,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),

                      //  CARD HOLDER NAME
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width * .05,
                          vertical: height * .03,
                        ),
                        height: height * .08,
                        child: TextFormField(
                          // onChanged: (val) => setState(() => () {}),
                          cursorColor: primaryColor,
                          readOnly: isLoading,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 20, color: primaryColor),
                          controller: cardHolderName,
                          // validator: (val) => _phoneValidator(val),
                          decoration: InputDecoration(
                            prefixIcon: Icon(CustomIcons.phone),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accentColor),
                            ),
                            labelText: 'Card Number',
                            labelStyle: TextStyle(
                              fontSize: 15,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      //  CVV
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width * .05,
                          vertical: height * .03,
                        ),
                        height: height * .08,
                        child: TextFormField(
                          onChanged: (val) => setState(() => cvvFocused = true),
                          onEditingComplete: () =>
                              setState(() => cvvFocused = false),
                          cursorColor: primaryColor,
                          readOnly: isLoading,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 20, color: primaryColor),
                          controller: cvvCode,
                          // validator: (val) => _phoneValidator(val),
                          decoration: InputDecoration(
                            prefixIcon: Icon(CustomIcons.phone),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accentColor),
                            ),
                            labelText: 'Card Number',
                            labelStyle: TextStyle(
                              fontSize: 15,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      //  EXPIRY DATE
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width * .05,
                          vertical: height * .03,
                        ),
                        height: height * .08,
                        child: TextFormField(
                          // onChanged: (val) => setState(() => () {}),
                          cursorColor: primaryColor,
                          readOnly: isLoading,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 20, color: primaryColor),
                          controller: expiryDate,
                          // validator: (val) => _phoneValidator(val),
                          decoration: InputDecoration(
                            prefixIcon: Icon(CustomIcons.phone),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accentColor),
                            ),
                            labelText: 'Expiry Date',
                            labelStyle: TextStyle(
                              fontSize: 15,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .01),
                      isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                              height: height * .06,
                              width: width * .6,
                              child: RaisedButton(
                                color: primaryColor,
                                // onPressed: () => _makePayment(),
                                child: Text(
                                  'COMPLETE PAYMENT',
                                  style: TextStyle(
                                    fontSize: width * .05,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: height * .01),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
