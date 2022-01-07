import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:intl/intl.dart';
import 'package:vendor/models/request.dart';
import 'package:vendor/widgets/requests_screen/sub_widgets/request_dialog.dart';

class RequestTile extends StatefulWidget {
  final Request request;
  RequestTile({@required this.request});

  @override
  _RequestTileState createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    // String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    if (int.parse(twoDigits(duration.inHours)) < 1)
      return "$twoDigitMinutes min ago";
    else
      return duration.inDays >= 1
          ? "${duration.inDays} ${duration.inDays > 1 ? 'days' : 'day'}, ${twoDigits(24 - duration.inHours.remainder(24) > 0 ? 24 - duration.inHours.remainder(24) : 0)} ${24 - duration.inHours.remainder(24) > 1 ? 'hrs' : 'hr'}, $twoDigitMinutes min ago"
          : "${twoDigits(duration.inHours)} hrs, $twoDigitMinutes min ago";
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).primaryColor;
    final request = widget.request;

    return Container(
      color:
          request.viewedByVendor ? Colors.white : primaryColor.withOpacity(0.3),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: request.paid
                ? null
                : () =>
                    RequestDialog(context: context, request: request).view(),
            leading: CircleAvatar(
              backgroundImage: AdvancedNetworkImage(
                request.scoutPhotoUrl,
                useDiskCache: true,
                fallbackAssetImage: 'assets/images/user.png',
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  request.scoutName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * .047,
                  ),
                ),
                Text(
                  _printDuration(
                      DateTime.now().difference(request.creationDate)),
                  // '${DateTime.now().difference(request.creationDate).inHours} hours, ${DateTime.now().difference(request.creationDate).inMinutes} minutes ago',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * .042,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              children: <Widget>[
                Text(
                  'Requested to book ${request.spaceName} on ${DateFormat.yMMMMEEEEd().format(request.eventDate)} at ${DateFormat.Hm().format(request.eventDate)} for ${request.hours} hours.',
                  style: TextStyle(
                    fontSize: width * .043,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Max attendants will be ${NumberFormat('#,###').format(request.maxCapacity)}.',
                      style: TextStyle(
                        fontSize: width * .043,
                      ),
                    ),
                    if (request.status == RequestStatus.PENDING)
                      Text(
                        'PENDING',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: width * .043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (request.status == RequestStatus.ACCEPTED)
                      Text(
                        'ACCEPTED',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: width * .043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (request.status == RequestStatus.REJECTED)
                      Text(
                        'REJECTED',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: width * .043,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            isThreeLine: true,
          ),
          Divider(
            thickness: 2,
            indent: width * .19,
          )
        ],
      ),
    );
  }
}
