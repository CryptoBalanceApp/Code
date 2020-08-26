import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:permission/permission.dart';

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
  //new csv https://icircuit.net/create-csv-file-flutter-app/2614
  _newCsv() async {
    print("in newCSV");
    List<List<dynamic>> entries = List<List<dynamic>>();
    //test list of list entries
    entries.add([1, "BTC", .1]);
    entries.add([2, "BTC", .05]);
    entries.add([3, "ETH", .15]);
    print("entries:");
    print(entries);
    //test .tocsv
    //permissions: https://stackoverflow.com/questions/50561737/getting-permission-to-the-external-storage-file-provider-plugin
    //https://pub.dev/packages/permission/example
    List<PermissionName> permRequestList = [];
    permRequestList.add(PermissionName.Storage);
    String message = '';
    var permissions = await Permission.requestPermissions(permRequestList);
    permissions.forEach((permission){
      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
    });
    setState(() {});
  }

  _getBalanceBody(){
    print("new balance body test!!!");

    _newCsv();
    return new Center(
      child: CircularProgressIndicator(),
    );
  }

  void initState() {
    //override creation: state call function
    super.initState();
    //call function to set state

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
