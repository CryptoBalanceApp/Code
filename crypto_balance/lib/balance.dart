import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//above: new package import https://pub.dev/packages/permission_handler/example
// import 'package:permission/permission.dart';
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
      //home: BalanceDisplay(),
      home: Scaffold(
        body: Center(
          child: BalanceDisplay(),
        ),
      ),
    );
  }
}
//ToDo: add this._permission... constructor? maybe don't need because just storage
class BalanceDisplay extends StatefulWidget {
  @override
  BalanceDisplayState createState() => BalanceDisplayState();
}

class BalanceDisplayState extends State<BalanceDisplay> with AutomaticKeepAliveClientMixin<BalanceDisplay> {
  //new csv https://icircuit.net/create-csv-file-flutter-app/2614

  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  @override
  void initState() {
    //override creation: state call function
    super.initState();
    print("permission status is : ${_permissionStatus}");
    print("in init state");
    print("platform is android: ${Platform.isAndroid}");
    //below: also from permission handler example
    _listenForPermission();
    //call function to set state
    //_getPermissionStatus();
    //_requestPermissions();
    print("permission status is : ${_permissionStatus}");

  }

  void _listenForPermission() async {
    print("in ListenFOrPermission");
    //final status = await Permission.location.status;
    final status = await Permission.storage.status;


    setState(() => _permissionStatus = status);

  }

  _newCsv() async {
    print("in newCSV");
    List<List<dynamic>> entries = List<List<dynamic>>();
    //test list of list entries
    entries.add([1, "BTC", .1]);
    entries.add([2, "BTC", .05]);
    entries.add([3, "ETH", .15]);
    print("entries:");
    print(entries);

    print("reached 5");

    setState(() {});
    print("reached 6");

  }

//  _getBalanceBody(){
//    print("new balance body test!!!");
//    //_newCsv();
//    //_getPermissionStatus();
//    print("reached 7");
//
//
//    return new Center(
//      child: CircularProgressIndicator(),
//    );
//  }

//  //https://pub.dev/packages/permission/example
//  _getPermissionStatus() async {
//    print("entered get permission status");
//    List<PermissionName> permName1 = [];
//    permName1.add(PermissionName.Storage);
//    String statmessage = '';
//    List<Permissions> perm1 = await Permission.getPermissionsStatus(permName1);
//    perm1.forEach((permission){
//      statmessage += '${permission.permissionName}: ${permission.permissionStatus}\n';
//    });
//
//    setState((){
//      print(statmessage);
//    });
//  }
//
//  //someone said this should help avoid crash? https://github.com/flutter/flutter/issues/48622
//  _requestPermissions() async {
//    print("enter 1");
//    List<PermissionName> permName2 = [];
//    print("enter 2");
//    permName2.add(PermissionName.Storage);
//    print("enter 3");
//    String statmessage2 = '';
//    print("enter 4");
//    //var perm2 = await Permission.requestPermissions(permName2);
//    List<Permissions> perm2 = await Permission.requestPermissions(permName2);
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
    //return Scaffold(
        //body: _getBalanceBody()
      return Center(
        child: CircularProgressIndicator(),
      );
    //);
  }

  //getter for keepclient alive mixin
  @override
  bool get wantKeepAlive => true;
}
