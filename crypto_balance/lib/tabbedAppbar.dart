
//import 'package:crypto_balance/Jerid.dart';
import 'package:crypto_balance/main.dart';
import 'package:flutter/material.dart';
import 'package:crypto_balance/references.dart';
import 'package:crypto_balance/balance.dart';

//
//List fromCurrAPI;
//var currMap = new Map();
String currencySelection = currUSD;

void main()=> runApp(MyApp1());

//set up string names
const String currUSD = "USD";
const String currJPY = "JPY";
const String currGBP = "GBP";
const String currMXN = "MXN";
const String currZAR = "ZAR";
const String currCNY = "CNY";
const String currEUR = "EUR";
const String currKRW = "KRW";
const String currINR = "INR";
const String currTHB = "THB";
const String currPHP = "PHP";

String helloString = "HelloWorld";
Map globalCryptoPrice = Map<String, dynamic>();
Map globalConvFac = Map<String, dynamic>();
String globalCurr = currUSD;

class Currency{
  final Text current;
  final String acronym;
  const Currency({
    this.current,
    this.acronym,
  });
}

const List<Currency> Currencies = <Currency>[
  const Currency(
    current: const Text('USD',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currUSD,
  ),
  const Currency(
    current: const Text('YEN',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currJPY,
  ),
  const Currency(
    current: const Text('Pound',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currGBP,
  ),
  const Currency(
    current: const Text('Peso',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currMXN,
  ),
  const Currency(
    current: const Text('Rand',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currZAR,
  ),
  const Currency(
    current: const Text('Rupee',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currINR,
  ),
  const Currency(
    current: const Text('Yaun',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currCNY,
  ),
  const Currency(
    current: const Text('Euro',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currEUR,
  ),
  const Currency(
    current: const Text('Won',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currKRW,
  ),
  const Currency(
    current: const Text('Baht',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currTHB,
  ),
  const Currency(
    current: const Text('Philippine',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currPHP,
  ),

];

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoBalance',
      home: MyTabbedPage(),
    );
  }
}
class MyTabbedPage extends StatefulWidget{
  const MyTabbedPage({Key key}): super(key:key);

  @override
  _MyTabbedPageState createState()=>_MyTabbedPageState();

}

class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Prices' ),
    Tab(text: 'Balance'),
    Tab(text: 'About')
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(105),
        child: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Image.asset(
                    'Assets/Logos/moneyTreeAndroid.png',
                    fit: BoxFit.contain,
                    height: 40, width: 40),
              ),

              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text('CryptoBalance',
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Color(0xff3E0CA9)),
                      textAlign: TextAlign.center))
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: myTabs,
          ),
        ),

      ),
      body: TabBarView(
        controller: _tabController,

        children:[
          MyApp(),
          MyApp4(),
          //MyApp2(),
          MyApp2(),


        ],
      ),
    );
  }
}