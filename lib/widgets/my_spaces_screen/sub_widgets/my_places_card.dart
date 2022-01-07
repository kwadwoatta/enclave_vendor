import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class MyPlacesCard extends StatefulWidget {
  final String spaceName;
  final String spaceLocation;
  final String coverPhoto;
  final int rating;
  final double price;
  final String city;

  MyPlacesCard({
    this.spaceName,
    this.spaceLocation,
    this.coverPhoto,
    this.rating,
    this.price,
    this.city,
  });

  @override
  _MyPlacesCardState createState() => _MyPlacesCardState();
}

class _MyPlacesCardState extends State<MyPlacesCard> {
  bool imageLoaded = false;
  bool imageFailed = false;
  Function reloadFunction;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: EdgeInsets.only(bottom: 15, left: 2, right: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Dismissible(
        key: ValueKey(widget.spaceName),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (contxt) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text(
                'Do you want to delete this space from your collection?',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'No',
                  ),
                  onPressed: () => Navigator.of(contxt).pop(false),
                ),
                RaisedButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Navigator.of(contxt).pop(true),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) => () {},
        // Provider.of<Cart>(context, listen: false).removeItem(productId),
        background: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Theme.of(context).errorColor,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 35,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  height: height * .2,
                  child: TransitionToImage(
                    image: AdvancedNetworkImage(
                      widget.coverPhoto,
                      loadedCallback: () {
                        setState(() => imageLoaded = true);
                      },
                      loadFailedCallback: () {
                        setState(() => imageFailed = true);
                      },
                      loadingProgress: (double progress, dataInInt) {
                        // print('Now Loading: $progress');
                      },
                    ),
                    loadingWidgetBuilder: (_, double progress, __) => Center(
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Theme.of(context).accentColor,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    placeholderBuilder: ((_, refresh) {
                      return Center(
                        child: InkWell(
                          onTap: refresh,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.refresh),
                              Text(
                                'Tap to retry',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    fit: BoxFit.fill,
                    placeholder: const Icon(Icons.refresh),
                    // width: width,
                    enableRefresh: true,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.spaceName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${widget.spaceLocation}, ${widget.city}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: height * .07),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '2km to venue',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '¢ ${widget.price}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text('/per hour'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star_border,
                            size: 17,
                            color: primaryColor,
                          ),
                          Icon(
                            Icons.star_border,
                            size: 17,
                            color: primaryColor,
                          ),
                          Icon(
                            Icons.star_border,
                            size: 17,
                            color: primaryColor,
                          ),
                          Icon(
                            Icons.star_border,
                            size: 17,
                            color: primaryColor,
                          ),
                          Icon(
                            Icons.star_border,
                            size: 17,
                            color: primaryColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
