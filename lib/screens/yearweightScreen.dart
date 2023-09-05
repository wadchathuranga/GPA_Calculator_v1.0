import 'package:flutter/material.dart';
import 'package:gpacalculator/components/popupMenu.dart';
import '../utils/db_helper_weight.dart';
import '../models/weightModel.dart';
import '../components/drawerMenu.dart';

class YearWeightScreen extends StatefulWidget {
  const YearWeightScreen({Key key}) : super(key: key);

  @override
  State<YearWeightScreen> createState() => _YearWeightScreenState();
}

class _YearWeightScreenState extends State<YearWeightScreen> {
  // Future<List<Weight>> weights;

  List<Weight> weightList;

  TextEditingController _ctrlW1 = TextEditingController();
  TextEditingController _ctrlW2 = TextEditingController();
  TextEditingController _ctrlW3 = TextEditingController();
  TextEditingController _ctrlW4 = TextEditingController();

  double yearW1;
  double yearW2;
  double yearW3;
  double yearW4;

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey();
  DatabaseHelperWeight dbHelperWeight;

  bool _validate = false;

  var data;

  @override
  void initState() {
    super.initState();
    dbHelperWeight = DatabaseHelperWeight();
    refreshList();
  }

  refreshList() async {
    weightList = await dbHelperWeight.getWeight();
    if (weightList == null) {
      print('DB Empty');
      Weight res = Weight(null, 0.25, 0.25, 0.25, 0.25);
      dbHelperWeight.addWeight(res);
      print('DB Filled Default');

    }
    setState(() {}); // refresh the state
    print('List Refreshed!');
  }

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
          title: Text('Weights'),
          actions: <Widget>[
            PopupMenu(),
          ],
        ),
        drawer: DrawerMenu(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RefreshIndicator(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          // color: Colors.blue,
                          color: Colors.deepPurple,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        'Year 1 Weight     :',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                        // validator: (val) {
                                        //   if (weightList == null && val ) {
                                        //     print('Validation 1 pass');
                                        //     return "";
                                        //   }
                                        //   return null;
                                        // },
                                        onSaved: (val) {
                                          if (val.isEmpty) {
                                            setState(() {
                                              yearW1 = data[0].yr_one;
                                            });
                                            // return null;
                                          } else {
                                            yearW1 = double.parse(val);
                                          }
                                        },
                                        controller: _ctrlW1,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Weight',
                                          // hintText: 'Enter Weight',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        'Year 2 Weight     :',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                        // validator: (val) => weightValidate(val),
                                        onSaved: (val) {
                                          if (val.isEmpty) {
                                            setState(() {
                                              yearW2 = data[0].yr_two;
                                            });
                                          } else {
                                            yearW2 = double.parse(val);
                                          }
                                        },
                                        controller: _ctrlW2,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Weight',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        'Year 3 Weight     :',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                        // validator: (val) => weightValidate(val),
                                        onSaved: (val) {
                                          if (val.isEmpty) {
                                            setState(() {
                                              yearW3 = data[0].yr_three;
                                            });
                                          } else {
                                            yearW3 = double.parse(val);
                                          }
                                        },
                                        controller: _ctrlW3,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Weight',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        'Year 4 Weight     :',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                        // validator: (val) => weightValidate(val),
                                        onSaved: (val) {
                                          if (val.isEmpty) {
                                            // setState(() {
                                            yearW4 = data[0].yr_four;
                                            // });
                                          } else {
                                            yearW4 = double.parse(val);
                                          }
                                        },
                                        controller: _ctrlW4,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Weight',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        height: 50.0,
                                        // color: Colors.blue,
                                        color: Colors.deepPurple,
                                        textColor: Colors.white,
                                        child: Text('Clear'),
                                        onPressed: clearControllers,
                                        onLongPress: clearTable,
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Expanded(
                                      child: MaterialButton(
                                        height: 50.0,
                                        // color: Colors.blue,
                                        color: Colors.deepPurple,
                                        textColor: Colors.white,
                                        child: Text('Save'),
                                        onPressed: saveAndUpdate,
                                        onLongPress: defaultWeightAdd,
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
                  // add here next widget
                  Container(
                    child: FutureBuilder(
                      future: dbHelperWeight.getWeight(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.hasError);
                        data = snapshot.data;
                        return snapshot.hasData
                            ? Column(
                                children: <Widget>[
                                  Text(
                                    'Year 1 Weight   :   ' +
                                        data[0].yr_one.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Year 2 Weight   :   ' +
                                          data[0].yr_two.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Year 3 Weight   :   ' +
                                        data[0].yr_three.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Year 4 Weight   :   ' +
                                          data[0].yr_four.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text('No Data');
                      },
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          // height: 50.0,
                          // color: Colors.blue,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text(
                            'Info',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          onPressed: () => showBottomSheet(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 1),
                () {},
              );
            },
          ),
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
            height: MediaQuery.of(context).size.height * 0.35,
            // color: Colors.blueAccent,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Text(
                          'In here you can add weight values according to each four years '
                          'If you are not set the any weight value, application will use default values (1/4) or (0.25) '
                          'for each year separately to compute the Final GPA value.',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                        Divider(),
                        Text(
                          'You can update weight values the way you want.\n'
                              'The weight value must between 0.00 and 1.00',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                        Divider(),
                        Text(
                          'RESET TO DEFAULT WEIGHT \n'
                          'Press and hold on the Clear button for few seconds then the system will automatically reset '
                          'the weight values to default values (0.25) for each year.',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }

  void clearControllers() {
    formKey.currentState.reset();
    _ctrlW1.clear();
    _ctrlW2.clear();
    _ctrlW3.clear();
    _ctrlW4.clear();
  }

  void defaultWeightAdd() {
    Weight res = Weight(null, 0.25, 0.25, 0.25, 0.25);
    dbHelperWeight.addWeight(res);
    refreshList();
  }

  void clearTable() {
    dbHelperWeight.dropWeightTable();
    refreshList();
  }

  // weightValidateYr1(val) {
  //   if (val != null) {
  //     if (double.parse(val) < 0.0 ||
  //         double.parse(val) == 0 ||
  //         double.parse(val) > 1.1) {
  //       return "Value must be between '0.0 - 1.1'";
  //     }
  //   }
  //   print('Validation Passed!');
  //   return null;
  // }

  void saveAndUpdate() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      try {
        if (data == null) {
          Weight res = Weight(null, yearW1, yearW2, yearW3, yearW4);
          dbHelperWeight.addWeight(res);
          clearControllers();
          refreshList();
        } else {
          Weight resUpdate = Weight(data[0].id, yearW1, yearW2, yearW3, yearW4);
          dbHelperWeight.updateWeight(resUpdate);
          clearControllers();
          refreshList();
        }
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
