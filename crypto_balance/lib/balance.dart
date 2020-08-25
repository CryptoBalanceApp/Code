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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getBalanceBody()
    );
  }
}
