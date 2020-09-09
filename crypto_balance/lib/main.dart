/* Initial working version of CryptoBalance app. Developed in Jan-Feb 2020 by
 * Robert Silver, Jerid Roberson, and Mike Moreno. Final project for CSE 58,
 * UC Santa Cruz Winter Quarter 2020
 *
 * Code sources/examples:
 * -crypto price/api: Cryptocurrency Pricing App, Bilguun Batbold, Medium
 *  https://medium.com/quick-code/build-a-simple-app-with-pull-to-refresh-and-favourites-using-flutter-77a899904e04
 * -"for each":
 *   //https://codingwithjoe.com/dart-fundamentals-working-with-lists/#looping
 * -decoding conversion rates
 *    https://lesterbotello.dev/2019/07/13/consuming-http-services-with-flutter/
 */

import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart' as http;

const currencyNames = Currencies;

void main() {
  runApp(MyApp1());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoBalance',
      //below: replace with home: CryptoList()?,
      home: PricesList(),
    );
  }
}

//create stateful widget, called from MaterialApp home
class PricesList extends StatefulWidget {
  //
  @override
  //purpose: call state creation
  PricesListState createState() => PricesListState();
}

//keep alive for tabs like https://github.com/fluttervn/tabbar_demo/blob/master/lib/screens/tab1.dart
//class PricesListState extends State<PricesList>{
class PricesListState extends State<PricesList> with AutomaticKeepAliveClientMixin<PricesList> {
  //create list type store prices from API
  List _cryptoPrices;
  Map _cryptoPriceMap = Map<String, dynamic>();
  Map _convertFactors;
  //set book value: control state if API loading
  bool _loading = false;

  /*function: future asynchronous, get prices when they load, initiate load
   * progress bar if API still loading
   */
  Future<void> getPricesAPI() async {
    //get price conversion data from API
    String _apiURLConv = "https://api.exchangeratesapi.io/latest?base=USD";
    String _apiURL = "https://api.coinpaprika.com/v1/tickers";

    //setState:
    setState(() {
      this._loading = true;
    });

    //waits for response from API
    http.Response apiResponseConv = await http.get(_apiURLConv);
    http.Response apiResponse = await http.get(_apiURL);

    //after that line execute, set state off of loading, decode response
    setState((){
      //below: decode the json rates into the convertFactors map
      this._convertFactors = json.decode(apiResponseConv.body)["rates"];
      // below: decode json from api response into format readable as a list
      this._cryptoPrices = jsonDecode(apiResponse.body);
      //for each crypto entry get the id variable, decide what to add
      _cryptoPrices.forEach((var entry){
        String ID = entry['id'];
        //function to add entries to map
        //add to crypto map based on ID
        List cryptoToAdd = ["btc-bitcoin", "eth-ethereum", "ltc-litecoin", "doge-dogecoin", "xlm-stellar", "bitcoin-cash", "xrp-xrp"];
        if(cryptoToAdd.contains(ID)){
          _cryptoPriceMap.putIfAbsent(entry['name'],()=> entry['quotes']['USD']['price']);
        }
      });
      print(_convertFactors);
      print(_cryptoPriceMap);
      print("!!!!!!!");
      print(helloString);
      globalCryptoPrice = _cryptoPriceMap;
      print(globalCryptoPrice);
      globalConvFac = _convertFactors;
      print(globalConvFac);


      //we have now loaded json into list, set loading false
      this._loading = false;
    });
    return;
  }

  /*rounding: take in crypto map (one of the sub arrays of the json), return a
   * string (crypto price) rounded to two decimals with a dollar sign
   */
  //String getCryptoPrice(Map selection) {
  String getCryptoPrice(String name, double selection) {
    //default decimals to round: 2 (to 1 penny value)
    int decimals_to_round = 2;
    //ToDo renaming this variable currencySelection, really necessary?
    String country = currencySelection;
    print("country selection is " + currencySelection);
    //ToDo: is below just the default currency symbol? remove?
    String currSymbol = "\$";
    //get conversion factor
    double countryConvert = this._convertFactors[country];
    print("country convert = " + countryConvert.toString());
    //Determine number of digits to round to based on crypto; lower valued cryptos are rounded to more numerals of precision
    /*pow: return 10^decimal: basic idea: multiply number by power of 10, round,
     *then divide by that same power 10: get rounded to decimals
     */
    switch(name){
      case "XRP": {
        decimals_to_round=6;
      }
      break;
      case "Stellar": {
        decimals_to_round=6;
      }
      break;
      case "Dogecoin": {
        decimals_to_round=6;
      }
      break;
    }
    int fac = pow(10, decimals_to_round);

    //multiply USD dollar value through conversion rate
    selection *= countryConvert;
    //determine which symbol character to use
    switch(country){
      case "USD": {
        currSymbol = "\$";
      }
      break;
      case "CNY": {
        currSymbol = "\¥";
      }
      break;
      case "ZAR": {
        currSymbol = "\R";
      }
      break;
      case "GBP": {
        currSymbol = "\£";
      }
      break;
      case "EUR": {
        currSymbol ="\€";
      }
      break;
      case "JPY": {
        currSymbol ="\円";
      }
      break;
      case "MXN": {
        currSymbol ="\$";
      }
      break;
      case "KRW": {
        currSymbol ="\₩";
      }
      break;
      case "INR": {
        currSymbol = "\₹";
      }
      break;
      case "THB": {
        currSymbol = "\฿";
      }
      break;
      case "PHP": {
        currSymbol = "\₱";
      }
      break;
    }
    //(selection = (selection * fac).round() / fac).toString()
    //return currSymbol + selection
    //or return selection + currSymbol
    //ToDo: simplify using above commented logic
    //round parsed using equation inside equation, add '$' or other symbol
    if((country != "EUR") && (country != "JPY")){
      //put symbol before number
      return currSymbol + (selection = (selection * fac).round() / fac).toString();
    }else{
      //else put symbol after number
      return (selection = (selection * fac).round() / fac).toString() + currSymbol;
    }
  }

  //implement getmainbody function, loading bar if _loading is true
  _getMainBody() {
    void _selectedCurrency(Currency currAbbrev) {
      setState(() {
        currencySelection = currAbbrev.acronym;
        globalCurr = currencySelection;
      });
    }
    //if loading API is true, create new center container for progress bar
    if(_loading) {
      return new Center(
        //note: make a child column <widget>[] to put logo over loading bar
        //use built in (material) circular loading bar, child of Center
        child: new CircularProgressIndicator(),
      );
    } else {
      //loading is done: return rest of app as body using _buildPricesList
      //Column: update box and list
      return new Column(
        children: <Widget>[
          new PopupMenuButton(
            itemBuilder: (BuildContext context){
              return Currencies.map((Currency currencie){
                //on select: command to make change when dropdown menu selected
                return new PopupMenuItem(
                  //value: text to display
                  value: currencie,
                  child: new ListTile(title: currencie.current, ),
                );
              }).toList();
              //onSelected:
            },
            onSelected: _selectedCurrency,
            color: Colors.white,
            icon: Icon(
              Icons.attach_money,
              color: Color(0xff3E0CA9),

            ),
          ),
          //nest in a refreshindicator widget, lets use use pull down to refresh
          RefreshIndicator(
            //make child a column, add icon
            child: _buildShortList(),
            onRefresh: getPricesAPI,
          ),
        ],
      );
    }
  }

  /* next: override initstate method, change how app initializes: have to
   * override and then call super.initState(); enable call to getPricesAPI on
   * app start and set app state
   */
  @override
  void initState() {
    //override creation: state call function
    super.initState();
    //call function to set state
    getPricesAPI();
  }
  //next: material design of app
  //build method
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _getMainBody(),
    );
  }

  //getter for keepclient alive mixin
  @override
  bool get wantKeepAlive => true;

  //widget builds list
  Widget _buildShortList() {
    //create iterable for map
    //https://api.flutter.dev/flutter/dart-core/Iterable-class.html
    final Iterable<ListTile> shortTiles = _cryptoPriceMap.keys.map
      ((crypto){
      //return new ListTile of Map
      return new ListTile(
        title: Text(crypto),
        subtitle: Text(
          //return price
          getCryptoPrice(crypto, _cryptoPriceMap[crypto]),
        ),
      );
    },
    );

    //make a divided list of the above ListTiles, use listview
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: shortTiles,
    ).toList();
    return new ListView(
      shrinkWrap: true,
      children: divided,
    );
    //make iterable tiles into list
  }
}