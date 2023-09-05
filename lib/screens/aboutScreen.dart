import 'dart:io';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:gpacalculator/components/popupMenu.dart';
import '../images.dart';
import '../components/drawerMenu.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenScreenState();
}

class _AboutScreenScreenState extends State<AboutScreen> {

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_key.currentState.isDrawerOpen) {
          _key.currentState.openEndDrawer();
          return Future.value(false);
        }
        Navigator.pushReplacementNamed(context, '/home');
        return Future.value(false);
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('About'),
          actions: <Widget>[
            PopupMenu(),
          ],
        ),
        drawer: DrawerMenu(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepPurple,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage(logo),
                        width: 75.0,
                        height: 75.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
                        child: Column(
                          children: [
                            Text(
                                'GPA Calculator is a mobile application to calculate your Grade Point Average (GPA).'
                                '\n\n'
                                'This is a 4.0 scalar GPA Calculator.'
                                '\n\n'
                                'The application allows users to compute Semester GPA, Year GPA, Current GPA and Final GPA '
                                'based on course credits and the grade achieved.'
                                '\n\n'
                                'If your university computes GPA with different weights for each year separately, '
                                'this app allows you to calculate Final GPA adding the weight values according to your university preference.',
                              textAlign: TextAlign.justify,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                              child: Divider(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Developed by Dilshan Chathuranga.'),
                                Text('Sabaragamuwa University of Sri Lanka.'),
                                SizedBox(height: 15),
                                TextButton.icon(
                                  onPressed: () async {
                                    String encodeQueryParameters(Map<String, String> params) {
                                      return params.entries
                                          .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                          .join('&');
                                    }

                                    final Uri emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: 'wadcweerasekara@gmail.com',
                                      query: encodeQueryParameters(<String, String>{
                                        'subject': 'Regarding Your GPA Calculator Mobile App',
                                      }),
                                    );

                                    launchUrl(emailLaunchUri);
                                  },
                                  label: Text('Email'),
                                  icon: Icon(Icons.mail_outline),
                                ),
                                Link(
                                  uri: Uri.parse('https://github.com/wadchathuranga'),
                                  target: LinkTarget.defaultTarget,
                                  builder: (BuildContext context, FollowLink followLink) {
                                    return TextButton.icon(
                                      onPressed: followLink,
                                      label: Text('Github'),
                                      icon: Icon(Icons.phonelink_outlined),
                                    );
                                  },
                                ),
                                Link(
                                  uri: Uri.parse('https://www.linkedin.com/in/wadchathuranga/'),
                                  target: LinkTarget.defaultTarget,
                                  builder: (BuildContext context, FollowLink followLink) {
                                    return TextButton.icon(
                                      onPressed: followLink,
                                      label: Text('Linked In'),
                                      icon: Icon(Icons.phonelink_outlined),
                                    );
                                  },
                                ),
                                SizedBox(height: 30),
                                Text('Copyright @2022 | All rights reserved.'),
                                SizedBox(height: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
