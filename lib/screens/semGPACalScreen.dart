import 'dart:core';
import 'package:flutter/material.dart';

import '../models/resultModel.dart';
import '../utils/database_helper.dart';
import 'homeScreen.dart';

class SemGPACalScreen extends StatefulWidget {
  final String tblName;
  const SemGPACalScreen(this.tblName);

  @override
  State<SemGPACalScreen> createState() => _SemGPACalScreenState();
}

class _SemGPACalScreenState extends State<SemGPACalScreen> {
  Future<List<Result>> results;

  TextEditingController _subCtrl = TextEditingController();
  TextEditingController _credCtrl = TextEditingController();
  var _selectedGrade;

  String subName;
  double grade;
  int credit;
  int currentUserID;

  GlobalKey<FormState> formKey = GlobalKey();

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  DatabaseHelper dbHelper;

  var gpaValue = 0.0;
  var totalCredits = 0;
  var totalGradeCredit;

  bool _validate = false;

  final List<Map> _grade = <Map>[
    {"grade": "A/A+", "value": "4.0"},
    {"grade": "A-", "value": "3.7"},
    {"grade": "B+", "value": "3.3"},
    {"grade": "B", "value": "3.0"},
    {"grade": "B-", "value": "2.7"},
    {"grade": "C+", "value": "2.3"},
    {"grade": "C", "value": "2.0"},
    {"grade": "C-", "value": "1.7"},
    {"grade": "D+", "value": "1.3"},
    {"grade": "D", "value": "1.0"},
    {"grade": "E", "value": "0.0"}
  ];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    refreshList();
  }


  refreshList() async {
    // Get total of (credit * grade)
    totalGradeCredit = await dbHelper.getCreditGrade(widget.tblName);

    // Get total credit
    totalCredits = await dbHelper.getTotalCredit(widget.tblName);

    setState(() {
      // Get all results
      results = dbHelper.getResult(widget.tblName);

      // Calculate semester gpa
      if (totalCredits != 0) {
        gpaValue = (totalGradeCredit / totalCredits);
      } else {
        gpaValue = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/semesters');
        return Future.value(false);
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('GPA Calculator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      // color: Colors.blue,   //  default colors
                      color: Colors.deepPurple,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 30.0, right: 10.0, bottom: 15),
                        child: Container(
                          // color: Colors.yellow,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'GPA',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Total Credits',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '   :   ',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '   :   ',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${gpaValue.toStringAsFixed(4)}',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$totalCredits',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // divider-1
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(),
                      ),
                      // form row
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 55,
                                    // color: Colors.redAccent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _subCtrl,
                                            onSaved: (val) => subName = val,
                                            validator: (val) {
                                              if (_subCtrl.text.isEmpty) {
                                                return 'Required!';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Subject',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            // color: Colors.redAccent,
                                            child: DropdownButtonHideUnderline(
                                              child:
                                                  DropdownButtonFormField<String>(
                                                validator: (val) {
                                                  if (_selectedGrade == null) {
                                                    return 'Required!';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Grade',
                                                ),
                                                items: _grade.map((gradeItem) {
                                                  return DropdownMenuItem(
                                                    value: gradeItem['value']
                                                        .toString(),
                                                    child: Text(gradeItem['grade']
                                                        .toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (newValueSelected) {
                                                  setState(() {
                                                    _selectedGrade =
                                                        newValueSelected;
                                                  });
                                                },
                                                value: _selectedGrade,
                                                isExpanded: false,
                                                onSaved: (val) =>
                                                    grade = double.parse(val),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            // keyboardType: TextInputType.number,
                                            controller: _credCtrl,
                                            validator: (val) {
                                              if (_credCtrl.text.isEmpty) {
                                                return 'Required!';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Credit',
                                            ),
                                            onSaved: (val) =>
                                                credit = int.parse(val),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: MaterialButton(
                                            height: 50.0,
                                            // color: Colors.blue,    // Default value
                                            color: Colors.deepPurple,
                                            textColor: Colors.white,
                                            child: Text('Add'),
                                            onPressed: validateAndSubmit,
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
                      // divider-2
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: results,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return resTable(snapshot.data);
                      }
                      if (snapshot.data == null || snapshot.data.legnth == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text("No Result Found!"),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                MaterialButton(
                  // color: Colors.blue,
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  child: Text('Info'),
                  onPressed: showBottomSheet,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView resTable(List<Result> results) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text("Subject"),
            ),
            DataColumn(
              label: Text("Grade"),
            ),
            DataColumn(
              label: Text("Credit"),
            ),
            DataColumn(
              label: Text("Action"),
            ),
          ],
          rows: results
              .map(
                (result) => DataRow(cells: [
                  DataCell(
                    Text(result.subject),
                  ),
                  DataCell(
                    result.grade.toString() == '4.0'
                        ? Text('A/A+')
                        : result.grade.toString() == '3.7'
                            ? Text('A-')
                            : result.grade.toString() == '3.3'
                                ? Text('B+')
                                : result.grade.toString() == '3.0'
                                    ? Text('B')
                                    : result.grade.toString() == '2.7'
                                        ? Text('B-')
                                        : result.grade.toString() == '2.3'
                                            ? Text('C+')
                                            : result.grade.toString() == '2.0'
                                                ? Text('C')
                                                : result.grade.toString() ==
                                                        '1.7'
                                                    ? Text('C-')
                                                    : result.grade.toString() ==
                                                            '1.3'
                                                        ? Text('D+')
                                                        : result.grade
                                                                    .toString() ==
                                                                '1.0'
                                                            ? Text('D')
                                                            : Text('E'),
                  ),
                  DataCell(
                    Text(result.credit.toString()),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dbHelper.delResult(result.id, widget.tblName);
                        setState(() {
                          refreshList();
                        });
                      },
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            // color: Colors.blueAccent,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'This is a 4.0 scalar GPA Calculator',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DataTable(
                        columns: [
                          DataColumn(
                            label: Text("Grade"),
                          ),
                          DataColumn(
                            label: Text("Scale"),
                          ),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              Text('A+'),
                            ),
                            DataCell(
                              Text('4.0'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('A'),
                            ),
                            DataCell(
                              Text('4.0'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('A-'),
                            ),
                            DataCell(
                              Text('3.7'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('B+'),
                            ),
                            DataCell(
                              Text('3.3'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('B'),
                            ),
                            DataCell(
                              Text('3.0'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('B-'),
                            ),
                            DataCell(
                              Text('2.7'),
                            ),
                          ]),
                        ],
                      ),
                      VerticalDivider(),
                      DataTable(
                        columns: [
                          DataColumn(
                            label: Text("Grade"),
                          ),
                          DataColumn(
                            label: Text("Scale"),
                          ),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              Text('C+'),
                            ),
                            DataCell(
                              Text('2.3'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('C'),
                            ),
                            DataCell(
                              Text('2.0'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('C-'),
                            ),
                            DataCell(
                              Text('1.7'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('D+'),
                            ),
                            DataCell(
                              Text('1.7'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('D'),
                            ),
                            DataCell(
                              Text('1.0'),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('E'),
                            ),
                            DataCell(
                              Text('0.0'),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void validateAndSubmit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      try {
        Result res = Result(null, subName, grade, credit);
        dbHelper.addResult(res, widget.tblName);

        setState(() {

          refreshList();

          _subCtrl.clear();
          _credCtrl.clear();
        });
      } catch (e) {
        print('Error: $e');
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
