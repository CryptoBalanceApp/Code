/* Initial working version of CryptoBalance app. Developed in Jan-Feb 2020 by
 * Robert Silver, Jerid Roberson, and Mike Moreno. Final project for CSE 58,
 * UC Santa Cruz Winter Quarter 2020
 *
 * Code sources/examples:
 * -crypto price/api: Cryptocurrency Pricing App, Bilguun Batbold, Medium
 *  https://medium.com/quick-code/build-a-simple-app-with-pull-to-refresh-and-favourites-using-flutter-77a899904e04
 */


import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;



void main() => runApp(MyApp());

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
  @override
  //purpose: call state creation
  PricesListState createState() => PricesListState();
}

class PricesListState extends State<PricesList>{
  //create list type store prices from API
  List _cryptoPrices;
  //SetMap:
  final _initialCryptos = Set<Map>(); //= new List(10);
  //set book value: control state if API loading
  bool _loading = false;

  /*function: future asynchronous, get prices when they load, initiate load
   * progress bar if API still loading
   */
  Future<void> getPricesAPI() async {
    //bitcoin API we are using
    String _apiURL =  "http://api.coinmarketcap.com/v1/ticker/";

    //before API called, set loading to true
    setState(() {
      _initialCryptos.clear();
      this._loading = true;
    });
    //waits for response from API
    http.Response apiResponse = await http.get(_apiURL);
    //after that line execute, set state off of loading, decode response
    setState((){
      // below: decode json from api response into format readable as a list
      this._cryptoPrices = jsonDecode(apiResponse.body);
      //we have now loaded json into list, set loading false

      //create for loop: search for bitcoin, ethereum... take as map, add to
      //_initialCryptos
      //for(MapEntry entry in this._cryptoPrices.asMap().entries)
      //String id = _cryptoPrices[0]['id'];
      //print(id);

      //for each:
      //https://codingwithjoe.com/dart-fundamentals-working-with-lists/#looping
      _cryptoPrices.forEach((var entry){
        //print('printing initial list');
        //int listLength = _cryptoPrices.
        String ID = entry['id'];
        if(ID == 'bitcoin' || ID == 'ethereum' || ID == 'xrp' || ID == 'dogecoin'){
          //this._initialCryptos[0] = entry;
          //print(this._initialCryptos[0]);
          if(_initialCryptos.contains(entry) == false) {
            _initialCryptos.add(entry);
            print("added crypto:" + ID);
          }
        }

      }); //
      //print(_initialCryptos);
      this._loading = false;
      //print list https://medium.com/flutter-community/useful-list-methods-in-dart-6e173cac803d
      //print(_initialCryptos.sublist(0));
    });
    return;
  }

  /*rounding: take in crypto map (one of the sub arrays of the json), return a
   * string (crypto price) rounded to two decimals with a dollar sign
   * NOTE!: This may be the function to alter based on international currency
   * choice
   */
  String getCryptoPrice(Map selection) {
    /*set number of decimals we wish to see for the crypto, eventually should
     *vary for each
    */
    int decimals_to_round = 2;
    /*pow: return 10^decimal: basic idea: multiply number by power of 10, round,
     *then divide by that same power 10: get rounded to decimals
     */
    int fac = pow(10, decimals_to_round);
    /*get price: parse "selection" (passed in crypto subarray from api), only
     *passing in the subarray with all the information for one cryptocurrency.
     *finds price based on the parse function for double, looking for the value
     *from API corresponding to that crypto's price_usd
     */
    double parsed = double.parse(selection['price_usd']);
    //round parsed using equation inside equation, add '$'
    return "\$" + (parsed = (parsed * fac).round() / fac).toString();
  }

  //implement getmainbody function, loading bar if _loading is true
  _getMainBody() {
    //if loading API is true, create new center container for progress bar
    if(_loading) {
      return new Center(
        //use built in (material) circular loading bar, child of Center
        child: new CircularProgressIndicator(),
      );
    } else {
      //loading is done: return rest of app as body using _buildPricesList
      //nest in a refreshindicator widget, lets use use pull down to refresh
      return new RefreshIndicator(
        child: _buildShortList(),
        onRefresh: getPricesAPI,
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
      appBar:PreferredSize(
          preferredSize: Size.fromHeight(60),
          child:AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title:Row(
                  children:[

                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child:Image.asset('Assets/Logos/moneyTreeAndroid.png',
                          fit: BoxFit.contain,
                          height: 40,width: 40),
                    ),

                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text('CryptoBalance',
                            style: TextStyle(fontFamily: 'Josefin Sans',
                                color: Color(0xff3E0CA9)), textAlign: TextAlign.center ))
                  ],
              ),
          ),
      ),
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
    return new ListView(children: divided);
    //make iterable tiles into list
  }

  Widget _buildPricesList() {
    //build items in a list view
    return ListView.builder(
      //set item count: ensure index in range, use built in .length function list
      itemCount: _cryptoPrices.length,
        //itemCount: _initialCryptos.length,
      //padding for list tile content
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
       //builder: return row for each index (if statement met)
       final index = i;
       /*if(_cryptoPrices[index]['name']== 'Bitcoin') {
         return _buildRow(_cryptoPrices[index]);
       }*/
       /* current: need a way to return a null or something similar, or
        * make another function to generate a selected list (like _saved) to
        * just display a certain number prices
        */
       return _buildRow(_cryptoPrices[index]);
       //return _buildRow(_initialCryptos[index]);
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