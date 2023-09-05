import 'package:flutter/material.dart';
import 'package:gpacalculator/utils/database_helper.dart';
import 'package:gpacalculator/utils/db_helper_weight.dart';

import '../main.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({Key key}) : super(key: key);

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {

  DatabaseHelper dbHelper;
  DatabaseHelperWeight dbHelperWeight;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelperWeight = DatabaseHelperWeight();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "ResetAllSem",
          child: Text("Clear All Semesters"),
        ),
        PopupMenuItem<String>(
          value: "Reset",
          child: Text("Reset App"),
        ),
      ],
      onSelected: (value) {
        if (value == 'Reset') {
          dbHelperWeight.dropWeightTable();
          dbHelper.dropResultTables();

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => MyApp()),
                  (Route<dynamic> route) => false);
        }
        if (value == 'ResetAllSem') {
          dbHelper.dropResultTables();

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => MyApp()),
                  (Route<dynamic> route) => false);
        }
      },
    );
  }
}



