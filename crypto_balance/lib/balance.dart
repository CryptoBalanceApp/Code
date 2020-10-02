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

//ToDo: this has no real purpose, remove... it's fun to click the button though
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
  //ToDo: don't need permstats?
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  bool _loading = true;
  List<List<dynamic>> sqlList;
  //ToDo: curId still messing up... maybe not right solution?
  int curID = 0;

  @override
  void initState() {
    //override creation: state call function
    super.initState();
    //below: also from permission handler example
    _listenForPermission();
    //call function to set state
    requestPermissionStore();
    //create new database/load local variables if already exists
    _newBalanceDB();

  }

  //new package import https://pub.dev/packages/permission_handler/example
  void _listenForPermission() async {

    final status = await Permission.storage.status;
    setState(() => _permissionStatus = status);
  }

  Future<void> requestPermissionStore() async {
    final status = await Permission.storage.request();
    setState((){
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

    //update sqllist to avoid null tiles error
    await _getDBList();
    await updateIndex();
  }

  //Todo: this could probably be replaced, or made part of transactList?
  //getDBList: query database to fill list<list<>> sqllist with data to populate scaffold
   _getDBList() async {
    WidgetsFlutterBinding.ensureInitialized();
    //connect to db
    final Future<Database> transDB = openDatabase(
      p.join(await getDatabasesPath(), dbPath),
      version: 1,
    );
    final Database db = await transDB;

    //use built in database type function query to get transactions table
    final List<Map<String, dynamic>> dbMap = await db.query('transactions');
    //convert map to list for tiles
    final List<List<dynamic>> dbList = [];
    //Todo: able to ditch while loop and use iterable?
    //convert each row of table to a list and add to list of lists
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

  //return a list of lists formatted
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

  //indexinc and update index: ensure we're on correct index
  //ToDo: did having separate indexincrement function really solve anything? not sure... both async...
  Future<void> _indexinc() async {
    List<Trans> currList = await transactionsList();
    //int nexID;
    if(currList.length > 0) {
      curID = currList[currList.length - 1].id;
      curID +=1;
    }else{
      curID = 0;
    }
  }

  //new way to update current made for fab but sould be consolidated
  //plus more efficient way with sql? https://stackoverflow.com/questions/61229942/how-to-get-the-id-from-next-inserted-element-before-that-is-created
  updateIndex() async {
    await _indexinc();
    print("curID is $curID");
    setState(() {});
  }

  //new version of insert made for fab but should be consolidated
  //making version outside of scope
  insertNewTran(Trans t) async {
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
      //conflictAlgorithm: ConflictAlgorithm.replace,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    setState(() {});
  }

  //ToDo: learn shared preferences for storing non-table key value pairs https://flutter.dev/docs/cookbook/persistence/key-value

  //ToDo: implement show dialog function
  // https://coflutter.com/flutter-how-to-show-dialog/
  // builder context fix: https://medium.com/@nils.backe/flutter-alert-dialogs-9b0bb9b01d28
  _showTransactDiag() {
    showDialog(
      context: context,
      //builder: (_) => new AlertDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("testDialog"),
          content: new Text("testContent"),
          actions: <Widget>[
            FlatButton(
              child: Text("close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

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
          title: Text("${key[0].toString()}: ${key[3].toString()}, ${key[2].toString()}, \$${key[4].toString()}"),
          //ToDo: parse date into more human readable
          subtitle: Text("${key[1].toString()}"),
        );
      },);

      final List<Widget> dividedDB = ListTile.divideTiles(
        context: context,
        tiles: smallTiles,
      ).toList();
      return new ListView(
        shrinkWrap: true,
        children: dividedDB,
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
          //ToDo: only incrementing correctly every two... solution to put all logic in same async function with waits? not sure
          _showTransactDiag();
          buttonPress++;
          Trans n = Trans(
            id: curID,
            time: DateTime.now(),
            cryp: "BTC",
            amt: (buttonPress*.66).toDouble(),
            dolVal: buttonPress.toDouble(),
          );
          print(n.toString());

          insertNewTran(n);
          print("you've pressed the button $buttonPress times");
          //ToDo: issue here is that the page doesn't reload after leaving this button pressed
          _getDBList();
          //dispose issue solved by if !mounted check? https://stackoverflow.com/questions/49340116/setstate-called-after-dispose
          if(mounted) {
            setState(() {});
          }
          updateIndex();

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


//ToDo: Functions that fulfill update, delete etc...
//update a transaction
//Future<void> updateTrans(Trans t) async {
//  final Database db = await transDB;
//  await db.update(
//    'transactions',
//    t.toMap(),
//    where: "id = ?",
//    whereArgs: [t.id],
//  );
//}
//
//Future<void> deleteTrans(int id) async {
//  final db = await transDB;
//  await db.delete(
//    'transactions',
//    where: "id = ?",
//    whereArgs: [id],
//  );
//}