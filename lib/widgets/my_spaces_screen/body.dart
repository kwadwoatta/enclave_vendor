import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/custom_icons/custom_icons.dart';
import 'package:vendor/models/space.dart';
import 'package:vendor/providers/request.dart';
import 'package:vendor/providers/space.dart';
import 'package:vendor/widgets/my_spaces_screen/sub_widgets/my_places_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isInit = true;

  didChangeDependencies() {
    if (isInit) {
      Provider.of<SpaceProvider>(context).retreiveUserSpaces();
      Provider.of<RequestProvider>(context).retreiveSpaceRequests();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primaryColor = Theme.of(context).primaryColor;
    final mySpaces = Provider.of<SpaceProvider>(context).mySpaces;
    final unviewedRequestsLength =
        Provider.of<RequestProvider>(context).unviewedRequestsLength;

    return Container(
      height: height * 7,
      padding: EdgeInsets.only(
        top: height * .03,
        left: width * .02,
        right: width * .02,
      ),
      child: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: mySpaces,
            builder:
                (BuildContext context, AsyncSnapshot<List<Space>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: primaryColor,
                  ),
                );
              else if (snapshot.hasData) {
                final spaces = snapshot.data;
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text(
                      "You don't have any spaces listed yet. Press on the add button below to post an event space.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * .05,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else
                  return ListView(
                    children: spaces.map((space) {
                      return MyPlacesCard(
                        coverPhoto: space.coverPhoto,
                        price: space.price,
                        spaceName: space.name,
                        spaceLocation: space.address,
                        rating: space.rating,
                        city: space.city,
                      );
                    }).toList(),
                  );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'No event space found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * .05,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(
                  child: Text(
                    'Oops, an error occured.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * .05,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else
                return Center(
                  child: Text(
                    'No event space found..',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * .05,
                      color: Colors.grey,
                    ),
                  ),
                );

              // if (snapshot.hasData) {
              //   final spaces = snapshot.data;
              //   return ListView(
              //     children: spaces.map((space) {
              //       return MyPlacesCard(
              //         coverPhoto: space.coverPhoto,
              //         price: space.price,
              //         spaceName: space.name,
              //         spaceLocation: space.address,
              //         rating: space.rating,
              //         city: space.city,
              //       );
              //     }).toList(),
              //   );
              // } else
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // if (snapshot.connectionState == ConnectionState.active) {
              //   if (snapshot.hasData) {
              //     final spaces = snapshot.data;
              //     return ListView(
              //       children: spaces.map((space) {
              //         return MyPlacesCard(
              //           coverPhoto: space.coverPhoto,
              //           price: space.price,
              //           spaceName: space.name,
              //           spaceLocation: space.address,
              //           rating: space.rating,
              //         );
              //       }).toList(),
              //     );
              //     // return ListView.builder(
              //     //   itemCount: spaces.length,
              //     //   itemBuilder: (context, index) {
              //     //     for (var space in spaces) {
              //     //       return MyPlacesCard(
              //     //         coverPhoto: space.coverPhoto,
              //     //         price: space.price,
              //     //         spaceName: space.name,
              //     //         spaceLocation: space.address,
              //     //         rating: space.rating,
              //     //       );
              //     //     }
              //     // return spaces.map((space) {
              //     //   return MyPlacesCard(
              //     //     coverPhoto: space.coverPhoto,
              //     //     price: space.price,
              //     //     spaceName: space.name,
              //     //     spaceLocation: space.address,
              //     //     rating: space.rating,
              //     //   );
              //     // }).reduce((widget, samewidget) {
              //     //   return samewidget;
              //     // });
              //     //   },
              //     // );
              //   } else
              //     return Center(
              //       child: Text(
              //         'You haven\'t added any space. Tap on the add button below to do so',
              //       ),
              //     );
              // } else if (snapshot.connectionState == ConnectionState.waiting) {
              //   if (snapshot.hasData) {
              //     final spaces = snapshot.data;
              //     return ListView(
              //       children: spaces.map((space) {
              //         return MyPlacesCard(
              //           coverPhoto: space.coverPhoto,
              //           price: space.price,
              //           spaceName: space.name,
              //           spaceLocation: space.address,
              //           rating: space.rating,
              //         );
              //       }).toList(),
              //     );
              //   } else
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              // } else
              //   return Center(
              //       child: Text(
              //     'Error',
              //   ));
            },
          ),
          StreamBuilder(
            stream: unviewedRequestsLength,
            builder: ((context, AsyncSnapshot<int> snapshot) {
              final requests = snapshot.data;
              if (snapshot.hasData)
                return Positioned(
                  bottom: height * .1,
                  right: width * .07,
                  child: Badge(
                    position: BadgePosition.topRight(),
                    padding: EdgeInsets.all(10),
                    badgeColor: primaryColor,
                    badgeContent: Text(
                      '$requests',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: FloatingActionButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/requests'),
                      mini: true,
                      heroTag: 'notifications',
                      child: Icon(
                        CustomIcons.ring,
                        size: 20,
                      ),
                    ),
                  ),
                );
              else
                return Positioned(
                  bottom: height * .1,
                  right: width * .07,
                  child: FloatingActionButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/requests'),
                    mini: true,
                    heroTag: 'notifications',
                    child: Icon(
                      CustomIcons.ring,
                      size: 20,
                    ),
                  ),
                );
            }),
          ),
          Positioned(
            bottom: height * .025,
            right: width * .07,
            child: FloatingActionButton(
              mini: true,
              onPressed: () =>
                  Navigator.of(context).pushNamed('/add-space-screen'),
              heroTag: 'addition',
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
