import 'dart:ffi';
import 'package:crypto_balance/tabbedAppbar.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/widgets.dart';

//below: needs to be future void like example?
void main() => runApp(MyApp4());

int buttonPress = 0;


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
  List<List<dynamic>> sqlList;
  int curID = 0;

  @override
  void initState() {
    //override creation: state call function
    super.initState();
    //below: also from permission handler example
    _listenForPermission();
    //call function to set state
    requestPermissionStore();

    //ToDo: these probably don't need to be 2 functions
    _newBalanceDB();
    _getDBList();

  }

  //new package import https://pub.dev/packages/permission_handler/example
  void _listenForPermission() async {

    final status = await Permission.storage.status;
    setState(() => _permissionStatus = status);

  }

  Future<void> requestPermissionStore() async {
    final status = await Permission.storage.request();
    setState((){
      print(status);
      _permissionStatus = status;
    });
  }

  //ToDo: combine sql functions
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

    //retrieve list
    Future<List<Trans>> transactList() async {
      final Database db = await transDB;
      final List<Map<String, dynamic>> dbMap = await db.query('transactions');
      return List.generate(dbMap.length, (i) {
        return Trans(
          id: dbMap[i]['id'],
          time: DateTime.parse(dbMap[i]['time']),
          cryp: dbMap[i]['cryp'],
          amt: dbMap[i]['amt'],
          dolVal: dbMap[i]['dolVal'],
        );
      });
    }

    //update a transaction
    Future<void> updateTrans(Trans t) async {
      final Database db = await transDB;
      await db.update(
        'transactions',
        t.toMap(),
        where: "id = ?",
        whereArgs: [t.id],
      );
    }

    Future<void> deleteTrans(int id) async {
      final db = await transDB;
      await db.delete(
        'transactions',
        where: "id = ?",
        whereArgs: [id],
      );
    }

    //ToDo: below: logic to get next index nexID... should be put in its own function
    //plus more efficient way with sql? https://stackoverflow.com/questions/61229942/how-to-get-the-id-from-next-inserted-element-before-that-is-created
    print("get current");
    List<Trans> currList = await transactList();
    print(currList);
    int nexID;
    if(currList.length > 0) {
      nexID = currList[currList.length - 1].id;
      nexID+=1;
    }else{
      nexID = 0;
    }
    print("nexID is $nexID");

    Trans testTrans = Trans(
      id: nexID,
      time: DateTime.now(),
      cryp: "BTC",
      amt: .15,
      dolVal: 25,
    );
    await insertTrans(testTrans);
    currList = await transactList();

  }



  //Todo: this could probably be replaced, or made part of transactList?
   _getDBList() async {
    WidgetsFlutterBinding.ensureInitialized();
    //connect to db
    final Future<Database> transDB = openDatabase(
      p.join(await getDatabasesPath(), dbPath),
      version: 1,
    );

    final Database db = await transDB;
    final List<Map<String, dynamic>> dbMap = await db.query('transactions');

    //convert map to list for tiles
    final List<List<dynamic>> dbList = [];
    //Todo: able to ditch while loop and use iterable?
    int i = 0;
    while(i < dbMap.length){
      List l = dbMap[i].values.toList();
      dbList.add(l);
      i++;
    };
    //update global variable sqlList
    sqlList = dbList;

    setState(() {
      _loading = false;
    });
  }


  //new version of get transaction list made for fab but should be consolidated
  Future<List<Trans>> transactionsList() async {
    WidgetsFlutterBinding.ensureInitialized();
    //connect to db
    final Future<Database> transDB = openDatabase(
      p.join(await getDatabasesPath(), dbPath),
      version: 1,
    );
    final Database db = await transDB;
    final List<Map<String, dynamic>> dbMap = await db.query('transactions');
    return List.generate(dbMap.length, (i) {
      return Trans(
        id: dbMap[i]['id'],
        time: DateTime.parse(dbMap[i]['time']),
        cryp: dbMap[i]['cryp'],
        amt: dbMap[i]['amt'],
        dolVal: dbMap[i]['dolVal'],
      );
    });
  }

  //new way to update current made for fab but sould be consolidated
  Future<void> updateIndex() async {
    List<Trans> currList = await transactionsList();
    print(currList);
    //int nexID;
    if(currList.length > 0) {
      curID = currList[currList.length - 1].id;
      curID +=1;
    }else{
      curID = 0;
    }
  }

  //new version of insert made for fab but should be consolidated
  //making version outside of scope
  Future<void> insertNewTran(Trans t) async {
    WidgetsFlutterBinding.ensureInitialized();
    //connect to db
    final Future<Database> transDB = openDatabase(
      p.join(await getDatabasesPath(), dbPath),
      version: 1,
    );

    final Database db = await transDB;
    await db.insert(
      'transactions',
      t.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );



  }

  //ToDo: learn shared preferences for storing non-table key value pairs https://flutter.dev/docs/cookbook/persistence/key-value

  Widget _getBalanceBody(){
    if(_loading){
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      );
    }else{
      //ToDo: this probably needs to be a scaffold or something

      //Display tiles of transactions with sqlList
      final Iterable<ListTile> smallTiles = sqlList.map((key){
        return new ListTile(
          title: Text("${key[3].toString()}: ${key[2].toString()}, \$${key[4].toString()}"),
          //ToDo: parse date into more human readable
          subtitle: Text("${key[1].toString()}"),
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

  //below: action button logic leading to showdialog for inputting new transaction

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBalanceBody(),
      floatingActionButton: FloatingActionButton(
        onPressed:(){

          buttonPress++;
          updateIndex();
          Trans n = Trans(
            id: curID,
            time: DateTime.now(),
            cryp: "BTC",
            amt: (buttonPress*.66).toDouble(),
            dolVal: buttonPress.toDouble(),
          );
          insertNewTran(n);
          print("you've pressed the button $buttonPress times");
          //ToDo: issue here is that the page doesn't reload after leaving this button pressed
          _getDBList();
          setState(() {});

        },
        child: Icon(Icons.add_circle_outline_outlined),
        backgroundColor: Colors.deepPurple,
      ),
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
