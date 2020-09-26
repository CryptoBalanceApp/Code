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

    return MaterialApp(
      title: "balance sheet",
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

    print("in init state");
    print("platform is android: ${Platform.isAndroid}");
    //below: also from permission handler example
    _listenForPermission();
    print("permission status is : ${_permissionStatus}");
    //call function to set state
    //ToDo: uneccesary if?
    if(_permissionStatus != PermissionStatus.granted) {
      requestPermissionStore();
    }
    print("permission status is : ${_permissionStatus}");

  }

  void _listenForPermission() async {
    print("in ListenFOrPermission");
    //final status = await Permission.location.status;
    final status = await Permission.storage.status;


    setState(() => _permissionStatus = status);

  }

  Future<void> requestPermissionStore() async {
    print("in reqPermStor");
    final status = await Permission.storage.request();
    setState((){
      print(status);
      _permissionStatus = status;
    });

  }

//  _newCsv() async {
//    print("in newCSV");
//    List<List<dynamic>> entries = List<List<dynamic>>();
//    //test list of list entries
//    entries.add([1, "BTC", .1]);
//    entries.add([2, "BTC", .05]);
//    entries.add([3, "ETH", .15]);
//    print("entries:");
//    print(entries);
//
//    print("reached 5");
//
//    setState(() {});
//    print("reached 6");
//
//  }
//

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
