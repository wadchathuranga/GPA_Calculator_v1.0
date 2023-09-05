import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpacalculator/components/popupMenu.dart';
import 'package:new_version/new_version.dart';

import '../main.dart';
import '../utils/db_helper_weight.dart';
import '../utils/database_helper.dart';
import '../components/drawerMenu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper dbHelper;
  DatabaseHelperWeight dbHelperWeight;

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

  var yr1GPA = 0.0;
  var yr2GPA = 0.0;
  var yr3GPA = 0.0;
  var yr4GPA = 0.0;

  var finalTotalGrade;
  var finalTotalCredit = 0;
  double finalGPA = 0.0;
  double currentGPA = 0.0;

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    dbHelper = DatabaseHelper();
    dbHelperWeight = DatabaseHelperWeight();
    refresh();
    // _checkVersion();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  // void _checkVersion() async {
  //   final newVersion = NewVersion(
  //     androidId: "com.novaexplore.gpacalculator",
  //   );
  //   final status = await newVersion.getVersionStatus();
  //   if (status != null) {
  //     if (status.canUpdate) {
  //       newVersion.showUpdateDialog(
  //         context: context,
  //         versionStatus: status,
  //         dialogTitle: "UPDATE AVAILABLE!",
  //         dismissButtonText: "Later",
  //         dialogText: "Please update the app from " + "${status.localVersion}" + " to " + "${status.storeVersion}",
  //         dismissAction: () {
  //           SystemNavigator.pop();
  //         },
  //         updateButtonText: "Update",
  //       );
  //     }
  //   }
  //   print("DEVICE : " + status.localVersion);
  //   print("STORE : " + status.storeVersion);
  // }

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

    // Get weight values
    var yr1Weight = await dbHelperWeight.getWeightValue('yr_one');
    var yr2Weight = await dbHelperWeight.getWeightValue('yr_two');
    var yr3Weight = await dbHelperWeight.getWeightValue('yr_three');
    var yr4Weight = await dbHelperWeight.getWeightValue('yr_four');

    setState(() {
      // 11
      if (totC11 != 0) {
        gpaValue11 = (totGC11 / totC11).toStringAsFixed(4);
      }
      // 12
      if (totC12 != 0) {
        gpaValue12 = (totGC12 / totC12).toStringAsFixed(4);
      }
      // 21
      if (totC21 != 0) {
        gpaValue21 = (totGC21 / totC21).toStringAsFixed(4);
      }
      // 22
      if (totC22 != 0) {
        gpaValue22 = (totGC22 / totC22).toStringAsFixed(4);
      }
      // 31
      if (totC31 != 0) {
        gpaValue31 = (totGC31 / totC31).toStringAsFixed(4);
      }
      // 32
      if (totC32 != 0) {
        gpaValue32 = (totGC32 / totC32).toStringAsFixed(4);
      }
      // 41
      if (totC41 != 0) {
        gpaValue41 = (totGC41 / totC41).toStringAsFixed(4);
      }
      // 42
      if (totC42 != 0) {
        gpaValue42 = (totGC42 / totC42).toStringAsFixed(4);
      }

      // Current Year GPA
      if (totC11 != 0 || totC12 != 0) {
        yr1GPA = ((totGC11+totGC12)/(totC11+totC12));
      } else {
        yr1GPA = ((totGC11+totGC12)/(totC11+totC12));
      }

      if (totC21 != 0 || totC22 != 0) {
        yr2GPA = ((totGC21+totGC22)/(totC21+totC22));
      } else {
        yr2GPA = ((totGC21+totGC22)/(totC21+totC22));
      }

      if (totC31 != 0 || totC32 != 0) {
        yr3GPA = ((totGC31+totGC32)/(totC31+totC32));
      } else {
        yr3GPA = ((totGC31+totGC32)/(totC31+totC32));
      }

      if (totC41 != 0 || totC42 != 0) {
        yr4GPA = ((totGC41+totGC42)/(totC41+totC42));
      } else {
        yr4GPA = ((totGC41+totGC42)/(totC41+totC42));
      }

      var arr = [];

      if (!yr1GPA.isNaN) {
        arr.add(yr1GPA);
      }
      if (!yr2GPA.isNaN) {
        arr.add(yr2GPA);
      }
      if (!yr3GPA.isNaN) {
        arr.add(yr3GPA);
      }
      if (!yr4GPA.isNaN) {
        arr.add(yr4GPA);
      }

      print('* $arr');

      double sum = 0.0;
      for (var i = 0; i < arr.length; i++) {
        sum = sum + arr[i];
      }

      // Current GPA
      if (arr.length != 0) {
        currentGPA = sum / arr.length;
      }


      if (!yr1GPA.isNaN) {
        finalGPA = yr1GPA * yr1Weight;
      }
      if (!yr2GPA.isNaN) {
        finalGPA = finalGPA + yr2GPA * yr2Weight;
      }
      if (!yr3GPA.isNaN) {
        finalGPA = finalGPA + yr3GPA * yr3Weight;
      }
      if (!yr4GPA.isNaN) {
        finalGPA = finalGPA + yr4GPA * yr4Weight;
      }



      // Final Credit value
      finalTotalCredit = (totC11 +
          totC12 +
          totC21 +
          totC22 +
          totC31 +
          totC32 +
          totC41 +
          totC42);

    });



      print('${(yr1GPA * yr1Weight)+(yr3GPA * yr2Weight)}');
      print('** ${yr1Weight}');
      print('*** ${finalGPA}');



  }

  //double tap to exit
  DateTime current;
  Future<bool> popped() {
    DateTime now = DateTime.now();
    if (_key.currentState.isDrawerOpen) {
      _key.currentState.openEndDrawer();
    } else if (current == null ||
        now.difference(current) > Duration(milliseconds: 1500)) {
      current = now;
      Fluttertoast.showToast(
          msg: "Press Again to Exit!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      return Future.value(true);
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            // color: Colors.blueAccent,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'CGPA - Current Grade Point Average',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Sem GPA - Semester Grade Point Average',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'FGPA - Final Grade Point Average',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '\n'
                      'This is a 4.0 scalar GPA Calculator',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /*------------------- popupMenuButton Widget ---------------------*/
  Widget popupMenuButton() {
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
  /*--------------- End // popupMenuButton Widget -----------------*/


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            PopupMenu(),
          ],
        ),
        drawer: DrawerMenu(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            // color: Colors.amber,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(
                // color: Colors.blue,  // default color
                color: Color(0xFF513e75),
              ),
            ),
            child: isLoading
                ?
            Center(
              child: CircularProgressIndicator(),
            )
                :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Current GPA',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Final GPA',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Total Credits',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '  :  ',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '  :  ',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '  :  ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${currentGPA.toStringAsFixed(4)}',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${finalGPA.isNaN ? '0.0000' : finalGPA.toStringAsFixed(4)}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$finalTotalCredit',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            indent: 30,
                            endIndent: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Year 1 CGPA : ${yr1GPA.isNaN ? "0.0000": yr1GPA.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              // dashboard row
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 1 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue11).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC11',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(indent: 100,endIndent: 100,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 2 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue12).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC12',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            indent: 30,
                            endIndent: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Year 2 CGPA : ${yr2GPA.isNaN ? "0.0000": yr2GPA.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 1 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue21).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC21',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(indent: 100,endIndent: 100,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 2 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue22).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC22',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            indent: 30,
                            endIndent: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Year 3 CGPA : ${yr3GPA.isNaN ? "0.0000": yr3GPA.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 1 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue31).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC31',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(indent: 100,endIndent: 100,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 2 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue32).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC32',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            indent: 30,
                            endIndent: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Year 4 CGPA : ${yr4GPA.isNaN ? "0.0000": yr4GPA.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 1 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue41).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC41',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(indent: 100,endIndent: 100,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Sem 2 GPA',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              'Total Credits',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  :  ${double.parse(gpaValue42).toStringAsFixed(4)}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '  :  $totC42',
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            indent: 30,
                            endIndent: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                            child: MaterialButton(
                              // height: 50.0,
                              // color: Colors.blue,  // default color
                              color: Colors.deepPurple,
                              textColor: Colors.white,
                              child: Text(
                                "Info",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              onPressed: () => showBottomSheet(),
                            ),
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
    );
  }
}
