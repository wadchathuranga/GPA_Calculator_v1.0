class Weight {
  static const Id = 'id';
  static const yearOne_weight = 'yr_one';
  static const yearTwo_weight = 'yr_two';
  static const yearThree_weight = 'yr_three';
  static const yearFour_weight = 'yr_four';

  int id;
  double yr_one;
  double yr_two;
  double yr_three;
  double yr_four;

  Weight(this.id, this.yr_one, this.yr_two, this.yr_three, this.yr_four);

  // Weight.map(dynamic obj){
  //   id = obj['id'];
  //   yr_one = obj[yearOne_weight];
  //   yr_two = obj[yearTwo_weight];
  //   yr_three = obj[yearThree_weight];
  //   yr_four = obj[yearFour_weight];
  // }

  // Convert Info Object to Map Object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{Id: id, yearOne_weight: yr_one, yearTwo_weight: yr_two, yearThree_weight: yr_three, yearFour_weight: yr_four};
    // if (id != null) map[colId] = id;
    return map;
  }

  // Extract result from Map Object
  Weight.fromMap(Map<String, dynamic> map) {
    id = map[Id];
    yr_one = map[yearOne_weight];
    yr_two = map[yearTwo_weight];
    yr_three = map[yearThree_weight];
    yr_four = map[yearFour_weight];
  }
}