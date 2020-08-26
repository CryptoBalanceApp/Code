import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission/permission.dart';
//import 'package:simple_permissions/simple_permissions.dart';

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
    //https://pub.dev/packages/simple_permissions/install
    //https://icircuit.net/create-csv-file-flutter-app/2614
//    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
//    bool checkPermission = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
//    if(checkPermission){
//      print("permission accepted!!!");
//    }


    //https://pub.dev/packages/permission/example
    List<PermissionName> permRequestList = [];
    print("reached 1");
    permRequestList.add(PermissionName.Storage);
    print("reached 2");
    String message = '';
    var permissions = await Permission.requestPermissions(permRequestList);
    print("reached 3");
    permissions.forEach((permission){
      print("reached 4");
      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
    });
    print("reached 5");

    setState(() {});
    print("reached 6");

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
