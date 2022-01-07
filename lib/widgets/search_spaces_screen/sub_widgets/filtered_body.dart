import 'package:flutter/material.dart';
import 'package:vendor/models/space.dart';
import 'package:vendor/widgets/search_spaces_screen/sub_widgets/space_card.dart';
import 'package:vendor/widgets/show_error_dialog.dart';

List<Widget> filteredBody({
  @required BuildContext context,
  @required Stream<int> spacesLength,
  @required Stream<List<Space>> spaces,
}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final primaryColor = Theme.of(context).primaryColor;

  return [
    Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.centerLeft,
      child: StreamBuilder(
        stream: spacesLength,
        builder: ((context, AsyncSnapshot<int> snapshot) {
          final spaces = snapshot.data;
          if (snapshot.hasData)
            return Text(
              '$spaces event spaces found',
              style: TextStyle(
                color: primaryColor,
                fontSize: 15,
              ),
            );
          else
            return Text(
              '-- event spaces found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            );
        }),
      ),
    ),
    Expanded(
      child: StreamBuilder(
        stream: spaces,
        builder: ((context, AsyncSnapshot<List<Space>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
              ),
            );
          else if (snapshot.hasData) {
            print('Has data');
            final spaces = snapshot.data;
            return ListView(children: [
              if (spaces.length > 0)
                ...spaces.map((space) {
                  return SpaceCard(
                    space: space,
                  );
                }).toList()
              else
                Center(
                  child: Text(
                    'No match found..',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
            ]);
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Oops, no event space found.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            ErrorDialog(context: context, error: snapshot.error);
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
                'Oops, no event space found.',
                style: TextStyle(
                  fontSize: width * .05,
                  color: Colors.white,
                ),
              ),
            );
        }),
      ),
    ),
  ];
}
