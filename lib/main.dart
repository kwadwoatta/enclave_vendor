import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vendor/providers/cities.dart';
import 'package:vendor/providers/events.dart';
import 'package:vendor/providers/request.dart';
import 'package:vendor/providers/space.dart';
import 'package:vendor/providers/user.dart';

import './services/userManagement.dart';
import './routes/routes.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(MyApp()),
  );
}

// const Map<int, Color> color = {
//   50: Color.fromRGBO(84, 211, 194, .1),
//   100: Color.fromRGBO(84, 211, 194, .2),
//   200: Color.fromRGBO(84, 211, 194, .3),
//   300: Color.fromRGBO(84, 211, 194, .4),
//   400: Color.fromRGBO(84, 211, 194, .5),
//   500: Color.fromRGBO(84, 211, 194, .6),
//   600: Color.fromRGBO(84, 211, 194, .7),
//   700: Color.fromRGBO(84, 211, 194, .8),
//   800: Color.fromRGBO(84, 211, 194, .9),
//   900: Color.fromRGBO(84, 211, 194, 1),
// };
// MaterialColor customThemeColor = MaterialColor(0xFF54d3c2, color);

// const Map<int, Color> color = {
//   50: Color.fromRGBO(100, 181, 246, .1),
//   100: Color.fromRGBO(100, 181, 246, .2),
//   200: Color.fromRGBO(100, 181, 246, .3),
//   300: Color.fromRGBO(100, 181, 246, .4),
//   400: Color.fromRGBO(100, 181, 246, .5),
//   500: Color.fromRGBO(100, 181, 246, .6),
//   600: Color.fromRGBO(100, 181, 246, .7),
//   700: Color.fromRGBO(100, 181, 246, .8),
//   800: Color.fromRGBO(100, 181, 246, .9),
//   900: Color.fromRGBO(100, 181, 246, 1),
// };
// MaterialColor customThemeColor = MaterialColor(0xFF64B5F6, color);

// const Map<int, Color> color = {
//   50: Color.fromRGBO(82, 173, 156, .1),
//   100: Color.fromRGBO(82, 173, 156, .2),
//   200: Color.fromRGBO(82, 173, 156, .3),
//   300: Color.fromRGBO(82, 173, 156, .4),
//   400: Color.fromRGBO(82, 173, 156, .5),
//   500: Color.fromRGBO(82, 173, 156, .6),
//   600: Color.fromRGBO(82, 173, 156, .7),
//   700: Color.fromRGBO(82, 173, 156, .8),
//   800: Color.fromRGBO(82, 173, 156, .9),
//   900: Color.fromRGBO(82, 173, 156, 1),
// };
// MaterialColor customThemeColor = MaterialColor(0xFF52AD9C, color);
const Map<int, Color> color = {
  50: Color.fromRGBO(55, 200, 136, .1),
  100: Color.fromRGBO(55, 200, 136, .2),
  200: Color.fromRGBO(55, 200, 136, .3),
  300: Color.fromRGBO(55, 200, 136, .4),
  400: Color.fromRGBO(55, 200, 136, .5),
  500: Color.fromRGBO(55, 200, 136, .6),
  600: Color.fromRGBO(55, 200, 136, .7),
  700: Color.fromRGBO(55, 200, 136, .8),
  800: Color.fromRGBO(55, 200, 136, .9),
  900: Color.fromRGBO(55, 200, 136, 1),
};
MaterialColor customThemeColor = MaterialColor(0xFF37c888, color);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CitiesProvider()),
        ChangeNotifierProvider(create: (context) => SpaceProvider()),
        ChangeNotifierProvider(create: (context) => RequestProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
      ],
      child: MaterialApp(
        title: 'Enclave Vendor',
        home: UserManagement().handleAuth(),
        initialRoute: '/',
        routes: routes,
        theme: ThemeData(
          // accentColor: Color(0xFFf1f3f2),
          // accentColor: Color(0xFFD8D8D8),
          // primaryColorDark: Color(0xFF323643),
          primarySwatch: customThemeColor,
          accentColor: Color(0xFF696969),
          fontFamily: 'RobotoCondensed',
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
