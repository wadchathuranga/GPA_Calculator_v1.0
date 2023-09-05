import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';

import './screens/aboutScreen.dart';
import './screens/gpacalculatorScreen.dar.dart';
import './screens/homeScreen.dart';
import './screens/yearweightScreen.dart';
import './screens/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

   void _checkVersion() async {
      final newVersion = NewVersion(androidId: 'com.novaexplore.gpacalculator');
      final status = await newVersion.getVersionStatus();
      newVersion.showAlertIfNecessary(context: context);
      print('Device : '+ status.localVersion);
      print('Store : '+ status.storeVersion);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        // brightness: Brightness.dark,
        // primaryColor: Color(0xFF513e75),
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/semesters': (context) => GPACalculatorScreen(),
        '/weight': (context) => YearWeightScreen(),
        '/about': (context) => AboutScreen(),
      },
      // home: SplashScreen(),
    );
  }
}

