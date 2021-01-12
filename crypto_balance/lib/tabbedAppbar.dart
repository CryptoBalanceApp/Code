//tabbedAppbar.dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:crypto_balance/pricesTab.dart';
import 'package:crypto_balance/balance.dart';
import 'package:crypto_balance/about.dart';

void main()=> runApp(BottomNavigation());

//ToDo: add author to references
/*
 Note: known bug unresolved with TabBarView, outlined here https://github.com/flutter/flutter/issues/27680
 Addressing by removing this tab implementation and switching to bottom tab bar outlined here
 https://medium.com/fluttervn/making-bottom-tabbar-with-flutter-5ff82e8defe0
 and here https://github.com/fluttervn/tabbar_demo/blob/master/lib/tab_containter_default.dart
 */

//bottom bar: for general app navigation
class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      title: 'CryptoBalance',
      home: TabContainerBottom(),

    );
  }
}

//below: from tab container bottom https://github.com/fluttervn/tabbar_demo/blob/master/lib/tab_containter_bottom.dart
class TabContainerBottom extends StatefulWidget {
  TabContainerBottom({Key key}) : super(key:key);

  @override
  _TabContainerBottomState createState() => _TabContainerBottomState();
}

class _TabContainerBottomState extends State<TabContainerBottom> {
  int tabIndex = 0;
  List<Widget> screenList;
  @override
  void initState() {
    super.initState();
    screenList = [
      //todo: change names to meaningful
      //PricePage: prices list (pricesTab.dart)
      PricePage(),
      //BalancePage: balances (balance.dart)
      BalancePage(),
      //ReferencesPage: references tab (references.dart)
      AboutPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(85),
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
          ),
        ),
        body: screenList[tabIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.indigoAccent,
          unselectedItemColor: Colors.blueAccent,
          backgroundColor: Colors.white70,
          currentIndex: tabIndex,
          onTap: (int index) {
            setState((){
              tabIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Prices',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_outlined),
              label: 'Balance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outlined),
              label: 'About',
            ),
          ],
        ),
        //backgroundColor: Colors.white30,
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}



