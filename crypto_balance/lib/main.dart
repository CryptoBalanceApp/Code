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
import 'package:crypto_balance/entities/factors.dart';
import 'package:crypto_balance/references.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

const currencyNames = Currencies;

void main() {

  //print(currencyList);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoBalance',
      //below: replace with home: CryptoList(),

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

class PricesListState extends State<PricesList>{
  //create list type store prices from API
  List _cryptoPrices;
  //List _conversionFactors;
  //SetMap:
  final _initialCryptos = Set<Map>();
  //factors: class created to handle API conversion and get "rates" map
  factors _convertFactors = factors();
  //set book value: control state if API loading
  bool _loading = false;

  /*function: future asynchronous, get prices when they load, initiate load
   * progress bar if API still loading
   */
  Future<void> getPricesAPI() async {
    //get price conversion data from API
    String _apiURLConv = "https://api.exchangeratesapi.io/latest?base=USD";
    String _apiURL = "https://api.coinpaprika.com/v1/tickers";
    setState(() {
      _initialCryptos.clear();
      this._loading = true;
    });
    //waits for response from API
    http.Response apiResponseConv = await http.get(_apiURLConv);
    http.Response apiResponse = await http.get(_apiURL);
    //after that line execute, set state off of loading, decode response
    setState((){
      //below: call constructor for factors to get map of rates
      //rates: <country code> : <conversion factor from USD>
      this._convertFactors = factors.fromJson(json.decode(apiResponseConv.body));
      // below: decode json from api response into format readable as a list
      this._cryptoPrices = jsonDecode(apiResponse.body);

      //for each crypto entry get the id variable, decide what to add
      _cryptoPrices.forEach((var entry){
        String ID = entry['id'];
        //function to add entries to map
        void add_map(){
          if(_initialCryptos.contains(entry) == false) {
            _initialCryptos.add(entry);
            print("added crypto:" + ID);
          }
        }
        //add to crypto map based on ID
        switch(ID){
          case "btc-bitcoin": {
            add_map();
          }
          break;
          case "eth-ethereum": {
            add_map();
          }
          break;
          case "ltc-litecoin": {
            add_map();
          }
          break;
          case "doge-dogecoin": {
            add_map();
          }
          break;
          case "xlm-stellar": {
            add_map();
          }
          break;
          case "bitcoin-cash": {
            add_map();
          }
          break;
          case "xrp-xrp": {
            add_map();
          }
          break;
          default: {
            //if not in short list of cryptos, skip
          }
          break;
        }
      });
      //we have now loaded json into list, set loading false
      this._loading = false;
    });
    return;
  }

  /*rounding: take in crypto map (one of the sub arrays of the json), return a
   * string (crypto price) rounded to two decimals with a dollar sign
   */
  String getCryptoPrice(Map selection) {
    /*set number of decimals we wish to see for the crypto, eventually should
     *vary for each
    */
    int decimals_to_round = 2;
    //iD: use to identify; a few cryptos need different rounding
    String iD = selection['id'];
    String country = currencySelection;
    print("country selection is " + currencySelection);
    String currSymbol = "\$";

    //this wrong?
    double countryConvert = this._convertFactors.rates[country];

    print("country convert = " + countryConvert.toString());
    /*pow: return 10^decimal: basic idea: multiply number by power of 10, round,
     *then divide by that same power 10: get rounded to decimals
     */
    switch(iD){
      case "xrp-xrp": {
        decimals_to_round=6;
      }
      break;
      case "xlm-stellar": {
        decimals_to_round=6;
      }
      break;
      case "doge-dogecoin": {
        decimals_to_round=6;
      }
      break;
    }
    int fac = pow(10, decimals_to_round);
    /*get price: parse "selection" (passed in crypto subarray from api), only
     *passing in the subarray with all the information for one cryptocurrency.
     *finds price based on the parse function for double, looking for the value
     *from API corresponding to that crypto's price_usd
     */
    double parsed = selection['quotes']['USD']['price'];
    //adjust the parsed price based on international conversion
    parsed *= countryConvert;

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
    //round parsed using equation inside equation, add '$' or other symbol
    if((country != "EUR") && (country != "JPY")){
      //not Yen: put symbol before number
      return currSymbol + (parsed = (parsed * fac).round() / fac).toString();
    }else{
      //is Yen: put symbol after number
      return (parsed = (parsed * fac).round() / fac).toString() + currSymbol;
    }
  }

  //implement getmainbody function, loading bar if _loading is true
  _getMainBody() {
    void _selectedCurrency(Currency currAbbrev) {
      setState(() {
        currencySelection = currAbbrev.acronym;
        //runApp(MyApp());
        //PricesList();
        print("selected currency is " + currencySelection);
        print("selected currency price is" );
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
            color: Colors.white, icon: Icon(Icons.more_vert,color: Color(0xff3E0CA9), ),
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

  //widget builds list
  Widget _buildShortList() {
    //create iterable for map
    final Iterable<ListTile> shortTiles = _initialCryptos.map(
          (crypto){
        //return new ListTile of Map
        return new ListTile(
          title: Text(crypto['name']),
          subtitle: Text(
            //return price
            getCryptoPrice(crypto),
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

  //below: used to display all currencies from API, not just selected few
  //ToDo: eventually: use in separate page to use as options to add new cryptos
  Widget _buildPricesList() {
    //build items in a list view
    return ListView.builder(
      //set item count: ensure index in range, use built in .length function list
        itemCount: _cryptoPrices.length,
        //padding for list tile content
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          //builder: return row for each index (if statement met)
          final index = i;
          return _buildRow(_cryptoPrices[index]);
        }
    );
  }

  //function to build row
  //pass in Map: key value pairing, inner array chosen crypto
  //keys i.e. id, name... values i.e. bitcoin, $3000
  //map comes from _cryptoPrices[index]
  Widget _buildRow(Map crypto){
    //return row with desired properties as ListTile material widget
    return ListTile(
      //title of crypto: from 'name' key
      title: Text(crypto['name']),
      //show price USD, subtitle
      subtitle: Text(
        getCryptoPrice(crypto),

      ),
    );
  }

}