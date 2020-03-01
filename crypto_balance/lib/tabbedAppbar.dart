
//import 'package:crypto_balance/Jerid.dart';
import 'package:crypto_balance/main.dart';
import 'package:flutter/material.dart';

List fromCurrAPI;

void main()=> runApp(MyApp1());


class Currency{
  final Text current;
  const Currency({this.current});


}
const List<Currency> Currencies = <Currency>[
  const Currency(current: const Text('USD',style: TextStyle(color: Color(0xff3E0CA9)),)),
  const Currency(current: const Text('YEN',style: TextStyle(color: Color(0xff3E0CA9)),)),
  const Currency(current:const Text('EURO',style: TextStyle(color: Color(0xff3E0CA9)),))
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
    Tab(text: 'Left' ),
    Tab(text: 'Right'),

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
          actions: <Widget>[
            new PopupMenuButton(itemBuilder: (BuildContext context){
              return Currencies.map((Currency currencie){
                //on select: command to make change when dropdown menu selected
                return new PopupMenuItem(child:
                new ListTile(title: currencie.current, ),);
              }).toList();
            },color: Colors.white, icon: Icon(Icons.more_vert,color: Color(0xff3E0CA9), ),)
          ],

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
