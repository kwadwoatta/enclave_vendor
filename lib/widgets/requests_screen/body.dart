import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/models/request.dart';
import 'package:vendor/providers/request.dart';
import 'package:vendor/widgets/requests_screen/sub_widgets/request_tile.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isInit = true;
  didChangeDependencies() {
    if (isInit) {
      Provider.of<RequestProvider>(context).retreiveSpaceRequests();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    final requestsStream = Provider.of<RequestProvider>(context).spaceRequests;

    Widget dayCategory({@required String day}) {
      return Padding(
        padding: EdgeInsets.only(
          top: height * .01,
          left: width * .05,
          bottom: height * .01,
        ),
        child: Text(
          day,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * .045),
        ),
      );
    }

    return SafeArea(
      child: StreamBuilder(
        stream: requestsStream,
        builder: ((context, AsyncSnapshot<List<Request>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              ),
            );
          else if (snapshot.hasData) {
            final requestsList = snapshot.data;
            //* TODAY'S REQUESTS
            List<Request> todaysRequests = requestsList
                .where(
                  (request) =>
                      DateTime.now().difference(request.creationDate).inDays <
                      1,
                )
                .toList();
            //* YESTERDAY'S REQUESTS
            List<Request> yesterdaysRequests = requestsList
                .where(
                  (request) =>
                      DateTime.now().difference(request.creationDate).inDays ==
                      1,
                )
                .toList();
            //* OLDER REQUESTS
            List<Request> olderRequests = requestsList
                .where(
                  (request) =>
                      DateTime.now().difference(request.creationDate).inDays >
                      1,
                )
                .toList();

            return ListView(
              children: <Widget>[
                dayCategory(day: 'Today'),
                ...todaysRequests.map((request) {
                  return RequestTile(
                    request: request,
                  );
                }).toList(),
                dayCategory(day: 'Yesterday'),
                ...yesterdaysRequests.map((request) {
                  return RequestTile(request: request);
                }).toList(),
                dayCategory(day: 'Older'),
                ...olderRequests.map((request) {
                  return RequestTile(request: request);
                }).toList(),
              ],
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Oops, no requests found.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // ErrorDialog(context: context, error: snapshot.error);
            return Center(
              child: Text(
                'Oops, an error occured.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
          } else
            return Center(
              child: Text(
                'Oops, no requests found.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
        }),
      ),
    );
  }
}
