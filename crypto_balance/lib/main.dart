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
    //bitcoin API we are using
    String _apiURL =  "http://api.coinmarketcap.com/v1/ticker/";
    //before API called, set loading to true
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

      //debug lines for API response conversion
      print("test print currencies");
      double canada = _convertFactors.rates["CAD"];
      double mexico = _convertFactors.rates["MXN"];
      print(canada);
      print(mexico);

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
          case "bitcoin": {
            add_map();
          }
          break;
          case "ethereum": {
            add_map();
          }
          break;
          case "litecoin": {
            add_map();
          }
          break;
          case "dogecoin": {
            add_map();
          }
          break;
          case "stellar": {
            add_map();
          }
          break;
          case "bitcoin-cash": {
            add_map();
          }
          break;
          case "xrp": {
            add_map();
          }
          break;
          default: {

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
   * NOTE!: This may be the function to alter based on international currency
   * choice
   *  -partially done: countryConvert: conversion factor:
   *   ToDo: replace hardcoded GBP with a string determined by drop down select
   */
  String getCryptoPrice(Map selection) {
    /*set number of decimals we wish to see for the crypto, eventually should
     *vary for each
    */
    int decimals_to_round = 2;
    //iD: use to identify; a few cryptos need different rounding
    String iD = selection['id'];
    String country = "MXN";
    double countryConvert = this._convertFactors.rates[country];
    /*pow: return 10^decimal: basic idea: multiply number by power of 10, round,
     *then divide by that same power 10: get rounded to decimals
     */
    switch(iD){
      case "xrp": {
      decimals_to_round=6;
      }
      break;
      case "stellar": {
        decimals_to_round=6;
      }
      break;
      case "dogecoin": {
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
    double parsed = double.parse(selection['price_usd']);
    parsed *= countryConvert;
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