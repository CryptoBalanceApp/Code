//important global variables accessible across tabs
//const currencyNames = Currencies;
import 'package:crypto_balance/assets/currency.dart';

String currencySelection = currUSD;

Map globalCryptoPrice = Map<String, dynamic>();
Map globalConvFac = Map<String, dynamic>();
String globalCurr = currUSD;
final String dbPath = "balance_db.db";

