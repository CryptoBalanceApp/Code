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
