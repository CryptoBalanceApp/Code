import 'dart:ffi';

import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/widgets.dart';

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

class BalanceDisplay extends StatefulWidget {
  @override
  BalanceDisplayState createState() => BalanceDisplayState();
}

class BalanceDisplayState extends State<BalanceDisplay> with AutomaticKeepAliveClientMixin<BalanceDisplay> {
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  bool _loading = true;
  File _test;
  String _contents;
  List<List<dynamic>> convList;

  @override
  void initState() {
    //override creation: state call function
    super.initState();
    //below: also from permission handler example
    _listenForPermission();
    //call function to set state
    requestPermissionStore();
    //ToDo: need to have logic here to only create new CSV if necessary, but still do loading test and contents?
    _newCsv();
    _newBalanceDB();

  }

  //new package import https://pub.dev/packages/permission_handler/example
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


  //ToDo: below uneeded after sql
  //get path, https://flutter.dev/docs/cookbook/persistence/reading-writing-files#1-find-the-correct-local-path
  Future<String> get _appPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _csvFile async {
    String locPath = await _appPath;
    return File('$locPath/test.txt');
  }

  Future<File> writeString(String S) async {
    final csvF = await _csvFile;
    return csvF.writeAsString(S);
  }

  //ToDo: should I be using a SQLlite database for this? https://flutter.dev/docs/cookbook/persistence/sqlite

  _newCsv() async {
    //new csv https://icircuit.net/create-csv-file-flutter-app/2614
    print("in newCSV");
    //ToDo: this is still just a test... need to only create newCSV if not already
    List<List<dynamic>> entries = List<List<dynamic>>();
    //test list of list entries
    var dat = new DateTime.utc(2020, 9, 24);
    entries.add([dat, "BTC", .1]);
    dat = new DateTime.utc(2020, 9, 25);
    entries.add([dat, "BTC", .05]);
    entries.add([dat, "ETH", .15]);
    //print("entries:");
    //print(entries);

    String nCsv = const ListToCsvConverter().convert(entries);

    _test = await writeString(nCsv);
    _contents = await _test.readAsString();
    //print("contents is ${_contents}");

    setState(() {
      _loading = false;
    });
  }

  //ToDo: need async function for all sql functions
  //begin sqlLite: persistence i.e. https://flutter.dev/docs/cookbook/persistence/sqlite
  _newBalanceDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> transDB = openDatabase(
      p.join(await getDatabasesPath(), dbPath),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY, time TEXT, cryp TEXT, amt REAL, dolVal REAL)",
        );
      },
      version: 1,
    );

    //insert new transaction
    Future<void> insertTrans(Trans t) async {
      final Database db = await transDB;
      await db.insert(
        'transactions',
        t.toMap(),
        //ToDo: not sure what ideal conflict alg is, maybe not replace
        conflictAlgorithm:  ConflictAlgorithm.replace,
      );
    }

    

    print("dbPath is $dbPath");
    Trans testTrans = Trans(
      id: 1,
      time: DateTime.now(),
      cryp: "BTC",
      amt: .15,
      dolVal: 25,
    );

//    print(testTrans.toString());
//    print(testTrans.toMap());
    await insertTrans(testTrans);


  }

  //would use integer unix time? https://www.sqlite.org/datatype3.html

  //ToDo: learn shared preferences for storing non-table key value pairs https://flutter.dev/docs/cookbook/persistence/key-value


  Widget _getBalanceBody(){
    if(_loading){
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      );
    }else{
      //ToDo: get rid of this csv to list converter... going to be from db
      List<List<dynamic>> convList = CsvToListConverter().convert(_contents);
      //print("convList is $convList");

      final Iterable<ListTile> smallTiles = convList.map((key){
        return new ListTile(
          title: Text("${key[0].toString()}, ${key[1]}, ${key[2]}"),
        );
      },);
      final List<Widget> dividedCSV = ListTile.divideTiles(
        context: context,
        tiles: smallTiles,
      ).toList();
      return new ListView(
        shrinkWrap: true,
        children: dividedCSV,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getBalanceBody()
    );

  }

  //getter for keepclient alive mixin
  @override
  bool get wantKeepAlive => true;
}

//class for transaction entries
class Trans {
  final int id;
  //using real to store date https://www.sqlitetutorial.net/sqlite-date/
  final DateTime time;
  final String cryp;
  final double amt;
  final double dolVal;
  Trans({this.id, this.time, this.cryp, this.amt, this.dolVal});

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'time': time.toString(),
      'cryp': cryp,
      'amt': amt,
      'dolVal': dolVal,
    };
  }

  @override
  String toString(){
    return 'Trans{id: $id, when: $time, cryp: $cryp, amt: $amt, \$: $dolVal }';
  }
}
