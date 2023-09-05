class Result {

  static const colId = 'id';
  static const colSubject = 'subject';
  static const colGrade = 'grade';
  static const colCredit = 'credit';

  int id;
  String subject;
  double grade;
  int credit;

  Result(this.id, this.subject, this.grade, this.credit);

  Result.map(dynamic obj){
    id = obj[colId];
    subject = obj[colSubject];
    grade = obj[colGrade];
    credit = obj[colCredit];
  }

  // int get id => _id;

  // set id(int value) {
  //   this._id = value;
  // }

  // String get subject => _subject;

  // set subject(String value) {
  //   this._subject = value;
  // }

  // double get grade => _grade;

  // set grade(double value) {
  //   this._grade = value;
  // }

  // int get credit => _credit;

  // set credit(int value) {
  //   this._credit = value;
  // }

  // Convert Info Object to Map Object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colId: id, colSubject: subject, colGrade: grade, colCredit: credit};
    // if (id != null) map[colId] = id;
    return map;
  }

  // Extract result from Map Object
  Result.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    subject = map[colSubject];
    grade = map[colGrade];
    credit = map[colCredit];
  }
}
