import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:crypto_balance/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/widgets.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

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
  //ToDo: does this need to be global, or should be in somewhere else?
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  bool _loading = true;
  List<List<dynamic>> sqlList;
  //ToDo: is there a better way to index database than with global variable updating? not sure
  int curID = 0;
  //ToDo: does this need to be a global variable or should just be in _showtransactdiag?
  Trans newTran;


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
  //ToDo: eventually need way to handle what type of currency to make dollar value more useful
  _newBalanceDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    //update sqllist to avoid null tiles error
    await _getDBList();
//    final Database db = await transDB;
    await updateIndex();
  }

  //getDBList: query database to fill list<list<>> sqllist with data to populate scaffold
   _getDBList() async {
    WidgetsFlutterBinding.ensureInitialized();
    //connect to db
    final Future<Database> transDB = openDatabase(
      p.join(await getDatabasesPath(), dbPath),
      //create transDB, a database of transactions initially holding an empty table with
      //transaction ID, time input, type of cryptocurrency, amount of that currency, and dollar value
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY, time TEXT, cryp TEXT, amt REAL, dolVal REAL)",
        );
      },
      version: 1,
    );
    final Database db = await transDB;

    //use built in database type function query to get transactions table
    final List<Map<String, dynamic>> dbMap = await db.query('transactions');
    //convert map to list for tiles
    final List<List<dynamic>> dbList = [];

    //convert each row of table to a list and add to list of lists
    for(var i in dbMap){
      List l = i.values.toList();
      dbList.add(l);
    }
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




  //ToDo: probably want to replace this dialog with a form https://stackoverflow.com/a/58359701/10432596
  //https://api.flutter.dev/flutter/widgets/Form-class.html
  //https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
  _showFormDialog() {
    final _formKey = GlobalKey<FormState>();
    List<String> inputs = [];
    newTran = null;
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: Stack(
            //clipBehavior: Clip.hardEdge,
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                right:-40,
                top: -40,
                child: InkResponse(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close_outlined),
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ),
              Form(
                //note: need to use onsaved?
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //first: dropdown field https://pub.dev/packages/dropdown_formfield
                    //ToDo: maybe not best package for dropdown field, text hint not updating, builtin exists here? https://api.flutter.dev/flutter/material/DropdownButtonFormField-class.html
                    //ToDo: add validators to dropdown field
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: DropDownFormField(
                        titleText: 'CryptoCurrency',
                        hintText: "",
                        value: "",
                        onSaved: (value){
                          setState(() {

                            inputs.insert(0, value);
                          });
                          },
                        onChanged: (value){
                          setState(() {
                            inputs.insert(0, value);
                          });
                          },
                        dataSource: [
                          {
                            "display": "Bitcoin",
                            "value": "Bitcoin",
                          },
                          {
                            "display": "Ethereum",
                            "value": "Ethereum",
                          },
                          {
                            "display": "XRP",
                            "value": "XRP",
                          },{
                            "display": "Litecoin",
                            "value": "Litecoin",
                          },{
                            "display": "Stellar",
                            "value": "Stellar",
                          },{
                            "display": "Dogecoin",
                            "value": "Dogecoin",
                          },

                        ],
                        textField: 'display',
                        valueField: 'value',


                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (String value){inputs.insert(0, value);},
                        validator: (value){
                          if(value.isEmpty){
                            return 'Field cannot be empty';
                          }
                          //https://api.flutter.dev/flutter/dart-core/double/tryParse.html
                          if(double.tryParse(value) == null){
                            return 'invalid number';
                          }
                          return null;
                        },
                        decoration: new InputDecoration(hintText: "Crypto Amt (i.e. 1.23)"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (String value){inputs.insert(0, value);},
                        validator: (value){
                          if(value.isEmpty){
                            return 'Field cannot be empty';
                          }
                          if(double.tryParse(value) == null){
                            return 'invalid number';
                          }
                          return null;
                        },
                        decoration: new InputDecoration(hintText: "Dollar Value (USD, i.e. 25.51)"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          if(mounted){
                            setState(() {
                              //use validator validate entries https://stackoverflow.com/a/58117942/10432596
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                double newAmt = double.parse(inputs[1]);
                                double newDol = double.parse(inputs[0]);
                                newTran = Trans(
                                  id: curID,
                                  time: DateTime.now(),
                                  cryp: inputs[2],
                                  amt: newAmt,
                                  dolVal: newDol,
                                );
                              }
                              if(newTran!=null){
                                print("newTran: ");
                                print(newTran.toString());
                                print("inputs: $inputs");
                                insertNewTran(newTran);
                                _getDBList();
                                updateIndex();
                              }
                              Navigator.of(context).pop();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBalanceBody(),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _showFormDialog();
          //dispose issue solved by if !mounted check? https://stackoverflow.com/questions/49340116/setstate-called-after-dispose
          if(mounted) {
            setState(() {});
          }
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

