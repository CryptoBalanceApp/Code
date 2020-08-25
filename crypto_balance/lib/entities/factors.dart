//create class to import currency conversion factors
class factors {
  //variable: rates: map of rates
  final Map<String, dynamic> rates;

  //constructor
  factors({this.rates});

  /*take in from json, use factory: create object custom mechanism, returns
   * "factors" object
   */

  factory factors.fromJson(Map<String, dynamic> json){
    return factors(
      //take in a json named json, return a "factors" instance (map of ac. to cur.)
      rates: json['rates'],
    );
  }

  void printrate(){
    print(rates);
  }

  Map<String, dynamic> returnMap(){
    return rates;
  }

}