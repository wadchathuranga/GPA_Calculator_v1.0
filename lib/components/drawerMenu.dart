import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/share.dart';

import '../images.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String _appName;
  String _appPackageName;
  String _appVersion;
  String _appBuildNumber;

  @override
  void initState() {
    _getAppInfo();
    super.initState();
  }

  void _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appName = packageInfo.appName;
      _appPackageName = packageInfo.packageName;
      _appVersion = packageInfo.version;
      _appBuildNumber = packageInfo.buildNumber;
    });
    // print(_appVersion);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: MediaQuery.of(context).size.width * 0.75,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage(logo),
                    width: 70,
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _appVersion != null
                        ? Text(
                            'GPA Calculator v$_appVersion',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          )
                        : Text(
                            'GPA Calculator v1.0',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                  ),
                  Text(
                    'Developed by Dishan Chathuranga',
                    style: TextStyle(color: Colors.white, fontSize: 10.0),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('GPA Calculator'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/semesters'),
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Year Weight'),
              onTap: () => Navigator.pushReplacementNamed(context, '/weight'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share this App'),
              onTap: () {
                // if you need close the drawer before pop up the share screen
                Navigator.of(context).pop();
                Share.share(
                  'https://play.google.com/store/apps/details?id=com.novaexplore.gpacalculator',
                  subject: 'GPA Calculator App',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () => Navigator.pushReplacementNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }
}
