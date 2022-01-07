import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:vendor/custom_icons/custom_icons.dart';

import 'package:vendor/providers/user.dart';
import 'package:vendor/widgets/show_error_dialog.dart';

class VerifyCardScreen extends StatefulWidget {
  static const routeName = "/verify-card";

  @override
  _VerifyCardScreenState createState() => _VerifyCardScreenState();
}

class _VerifyCardScreenState extends State<VerifyCardScreen> {
  UserProvider userProvider;
  bool consentGiven = false;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context);
    super.didChangeDependencies();
  }

  Future<void> _addCreditCard() async {
    Navigator.of(context).pushNamed("/add-credit-card");
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final primaryColor = Theme.of(context).primaryColor;

    Widget listItem({
      @required IconData icon,
      @required String text,
      @required bool completed,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: completed ? Colors.green : Colors.red,
          ),
          SizedBox(width: screenSize.width * .06),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: completed ? Colors.grey : Colors.red,
              decoration: completed ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      );
    }

    void _showConsentDialog() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return Dialog(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 5, top: 10),
                  height: screenSize.height * .2,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Agreement',
                        style: TextStyle(fontSize: screenSize.width * .05),
                      ),
                      SizedBox(height: screenSize.height * .01),
                      Text(
                        'Check the box below to agree to collection of personal data to enable you to perform transactions.',
                        style: TextStyle(fontSize: screenSize.width * .04),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            value: consentGiven,
                            onChanged: (val) =>
                                setState(() => consentGiven = val),
                          ),
                          Text(
                            'I AGREE',
                            style: TextStyle(
                              fontSize: screenSize.width * .04,
                              color: consentGiven ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.bold,
                              decoration: consentGiven
                                  ? null
                                  : TextDecoration.lineThrough,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenSize.width * .05,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text(
                              'PROCEED',
                              style: TextStyle(
                                color:
                                    consentGiven ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.width * .05,
                              ),
                            ),
                            onPressed: consentGiven
                                ? () {
                                    Navigator.of(context).pop();
                                    _addCreditCard();
                                  }
                                : null,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('VERIFICATIONS'),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CustomIcons.add_credit_card),
        onPressed: _showConsentDialog,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            listItem(
              completed: true,
              icon: CustomIcons.security,
              text: 'Phone number verification complete',
            ),
            SizedBox(height: screenSize.height * .02),
            listItem(
              completed: true,
              icon: CustomIcons.security,
              text: 'Business email verification complete',
            ),
            SizedBox(height: screenSize.height * .02),
            listItem(
              completed: false,
              icon: CustomIcons.warning,
              text: 'Add credit card information',
            ),
            SizedBox(height: screenSize.height * .02),
          ],
        ),
      ),
    );
  }
}
