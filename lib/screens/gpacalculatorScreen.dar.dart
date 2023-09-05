import 'package:flutter/material.dart';
import 'package:gpacalculator/components/popupMenu.dart';
import 'package:gpacalculator/utils/database_helper.dart';
import './semGPACalScreen.dart';
import '../components/drawerMenu.dart';

class GPACalculatorScreen extends StatefulWidget {
  @override
  State<GPACalculatorScreen> createState() => _GPACalculatorScreen();
}

class _GPACalculatorScreen extends State<GPACalculatorScreen> {
  DatabaseHelper dbHelper;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  var totGC11;
  var totGC12;
  var totGC21;
  var totGC22;
  var totGC31;
  var totGC32;
  var totGC41;
  var totGC42;

  var totC11 = 0;
  var totC12 = 0;
  var totC21 = 0;
  var totC22 = 0;
  var totC31 = 0;
  var totC32 = 0;
  var totC41 = 0;
  var totC42 = 0;

  var gpaValue11 = '0';
  var gpaValue12 = '0';
  var gpaValue21 = '0';
  var gpaValue22 = '0';
  var gpaValue31 = '0';
  var gpaValue32 = '0';
  var gpaValue41 = '0';
  var gpaValue42 = '0';

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    pullToRefresh();
    refresh();
  }

  Future<Null> pullToRefresh() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));
    refresh();
    return null;
  }

  refresh() async {
    // Get total of (credit * grade)
    totGC11 = await dbHelper.getCreditGrade('tbl_one_one');
    totGC12 = await dbHelper.getCreditGrade('tbl_one_two');
    totGC21 = await dbHelper.getCreditGrade('tbl_two_one');
    totGC22 = await dbHelper.getCreditGrade('tbl_two_two');
    totGC31 = await dbHelper.getCreditGrade('tbl_three_one');
    totGC32 = await dbHelper.getCreditGrade('tbl_three_two');
    totGC41 = await dbHelper.getCreditGrade('tbl_four_one');
    totGC42 = await dbHelper.getCreditGrade('tbl_four_two');

    // Get total credit
    totC11 = await dbHelper.getTotalCredit('tbl_one_one');
    totC12 = await dbHelper.getTotalCredit('tbl_one_two');
    totC21 = await dbHelper.getTotalCredit('tbl_two_one');
    totC22 = await dbHelper.getTotalCredit('tbl_two_two');
    totC31 = await dbHelper.getTotalCredit('tbl_three_one');
    totC32 = await dbHelper.getTotalCredit('tbl_three_two');
    totC41 = await dbHelper.getTotalCredit('tbl_four_one');
    totC42 = await dbHelper.getTotalCredit('tbl_four_two');

    setState(() {
      // 11
      if (totC11 != 0) {
        gpaValue11 = (totGC11 / totC11).toStringAsFixed(4);
      } else {
        gpaValue11 = '0';
      }
      // 12
      if (totC12 != 0) {
        gpaValue12 = (totGC12 / totC12).toStringAsFixed(4);
      } else {
        gpaValue12 = '0';
      }
      // 21
      if (totC21 != 0) {
        gpaValue21 = (totGC21 / totC21).toStringAsFixed(4);
      } else {
        gpaValue21 = '0';
      }
      // 22
      if (totC22 != 0) {
        gpaValue22 = (totGC22 / totC22).toStringAsFixed(4);
      } else {
        gpaValue22 = '0';
      }
      // 31
      if (totC31 != 0) {
        gpaValue31 = (totGC31 / totC31).toStringAsFixed(4);
      } else {
        gpaValue31 = '0';
      }
      // 32
      if (totC32 != 0) {
        gpaValue32 = (totGC32 / totC32).toStringAsFixed(4);
      } else {
        gpaValue32 = '0';
      }
      // 41
      if (totC41 != 0) {
        gpaValue41 = (totGC41 / totC41).toStringAsFixed(4);
      } else {
        gpaValue41 = '0';
      }
      // 42
      if (totC42 != 0) {
        gpaValue42 = (totGC42 / totC42).toStringAsFixed(4);
      } else {
        gpaValue42 = '0';
      }
    });
  }

/*--------------- AlertDialogBox Widget -----------------*/
  showAlertDialog(BuildContext context, String tblName) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(
          color: Colors.deepPurple,
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
          color: Colors.deepPurple,
        ),
      ),
      onPressed: () {
        dbHelper.dropSpecificTable(tblName);
        setState(() {
          refresh();
        });
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning!"),
      content: Text("Are you sure to delete all data from $tblName?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  /*--------------- End // AlertDialogBox Widget -----------------*/

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
          title: Text('Semesters'),
          actions: <Widget>[
            PopupMenu(),
          ],
        ),
        drawer: DrawerMenu(),
        body: RefreshIndicator(
          key: refreshKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  // color: Colors.blue,   // default color value
                  color: Colors.deepPurple,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Divider(
                          //   indent: 10,
                          //   endIndent: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 1 Semester 1',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue11',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC11',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_one_one")),
                                    ),
                                    trailing: totC11 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_one_one"),
                                          ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 1 Semester 2',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue12',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC12',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_one_two")),
                                    ),
                                    trailing: totC12 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_one_two"),
                                          ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 2 Semester 1',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue21',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC21',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_two_one")),
                                    ),
                                    trailing: totC21 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_two_one"),
                                          ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 2 Semester 2',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue22',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC22',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_two_two")),
                                    ),
                                    trailing: totC22 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_two_two"),
                                          ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 3 Semester 1',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue31',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC31',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_three_one")),
                                    ),
                                    trailing: totC31 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_three_one"),
                                          ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 3 Semester 2',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue32',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC32',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_three_two")),
                                    ),
                                    trailing: totC32 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_three_two"),
                                          ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 4 Semester 1',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue41',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC41',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_four_one")),
                                    ),
                                    trailing: totC41 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_four_one"),
                                          ),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Year 4 Semester 2',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'GPA : $gpaValue42',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          Text(
                                            'Total Credits : $totC42',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SemGPACalScreen("tbl_four_two")),
                                    ),
                                    trailing: totC42 == 0
                                        ? IconButton(
                                            icon: Icon(Icons.add),
                                            // onPressed: (){},
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => showAlertDialog(
                                                context, "tbl_four_two"),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onRefresh: pullToRefresh,
        ),
      ),
    );
  }
}
