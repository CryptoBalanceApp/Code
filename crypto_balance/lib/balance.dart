import 'package:crypto_balance/tabbedAppbar.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp4());

class MyApp4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    return MaterialApp(
      title: "balance sheet",
      home: BalanceDisplay(),
    );
  }
}

class BalanceDisplay extends StatefulWidget {
  @override
  BalanceDisplayState createState() => BalanceDisplayState();
}

class BalanceDisplayState extends State<BalanceDisplay>{
  _getBalanceBody(){

    return new Center(
      child: CircularProgressIndicator(),
    );
  }

  void initState() {
    //override creation: state call function
    super.initState();
    //call function to set state
    print("test print in balance!!!!!");
    print("global crypto: ");
    print(globalCryptoPrice);
    print("global conversion: ");
    print(globalConvFac);
    print(globalCurr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getBalanceBody()
    );
  }
}
