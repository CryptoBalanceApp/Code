
//import 'package:crypto_balance/Jerid.dart';
import 'package:crypto_balance/main.dart';
import 'package:flutter/material.dart';

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
    current: const Text('Pounds',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currGBP,
  ),
  const Currency(
    current: const Text('Pesos',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currMXN,
  ),
  const Currency(
    current: const Text('Rand',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currZAR,
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



  //const Currency(current: const Text('CNY',style: TextStyle(color: Color(0xff3E0CA9)),)),
  //const Currency(current: const Text('EUR',style: TextStyle(color: Color(0xff3E0CA9)),)),
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
    Tab(text: 'About'),

  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }
  /*
  void _selectedCurrency(Currency currAbbrev) {
    setState(() {
      currencySelection = currAbbrev.current.toString();

      //runApp(MyApp());
      //PricesList();
      print("selected currency is " + currencySelection);
      print("selected currency price is" );

    });
  } */

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
          //beginning of dropdown tabs
          /*actions: <Widget>[
            new PopupMenuButton(itemBuilder: (BuildContext context){
              return Currencies.map((Currency currencie){
                //on select: command to make change when dropdown menu selected
                return new PopupMenuItem(
                  value: currencie,
                  child: new ListTile(title: currencie.current, ),
                );
              }).toList();
              //onSelected:
              },
              onSelected: _selectedCurrency,
              color: Colors.white, icon: Icon(Icons.more_vert,color: Color(0xff3E0CA9), ),
            ),
          ],*/

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
          MyApp()


        ],
      ),
    );
  }
}
