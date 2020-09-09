import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission/permission.dart';
//import 'package:simple_permissions/simple_permissions.dart';

//below: needs to be future void like example?
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


//    //https://pub.dev/packages/permission/example
//    List<PermissionName> permRequestList = [];
//    print("reached 1");
//    permRequestList.add(PermissionName.Storage);
//    print("reached 2");
//    String message = '';
//    var permissions = await Permission.requestPermissions(permRequestList);
//
//    print("reached 3");
//    permissions.forEach((permission){
//      print("reached 4");
//      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
//    });

    print("reached 5");

    setState(() {});
    print("reached 6");

  }



  _getBalanceBody(){
    print("new balance body test!!!");
    //_newCsv();
    //_getPermissionStatus();
    print("reached 7");


    return new Center(
      child: CircularProgressIndicator(),
    );
  }

  void initState() {
    //override creation: state call function
    super.initState();
    //call function to set state
    _getPermissionStatus();
    //_requestPermissions();
    print("exit request");

    print("global crypto: ");
    print(globalCryptoPrice);
    print("global conversion: ");
    print(globalConvFac);
    print(globalCurr);


  }

  //https://pub.dev/packages/permission/example
  _getPermissionStatus() async {
    List<PermissionName> permName1 = [];
    permName1.add(PermissionName.Storage);
    String statmessage = '';
    List<Permissions> perm1 = await Permission.getPermissionsStatus(permName1);
    perm1.forEach((permission){
      statmessage += '${permission.permissionName}: ${permission.permissionStatus}\n';
    });

    setState((){
      print(statmessage);
    });
  }

//  _requestPermissions() async {
//    print("enter 1");
//    List<PermissionName> permName2 = [];
//    print("enter 2");
//    permName2.add(PermissionName.Storage);
//    print("enter 3");
//    String statmessage2 = '';
//    print("enter 4");
//    var perm2 = await Permission.requestPermissions(permName2);
//    print("enter 5");
//    perm2.forEach((permission){
//      statmessage2 += '${permission.permissionName}: ${permission.permissionStatus}\n';
//    });
//    print("enter 6");
//    setState((){
//      print(statmessage2);
//    });
//
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getBalanceBody()
    );
  }
}
