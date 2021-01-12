/* Initial working version of CryptoBalance app. Developed in Jan-Feb 2020 by
 * Robert Silver, Jerid Roberson, and Mike Moreno. Final project for CSE 58,
 * UC Santa Cruz Winter Quarter 2020
 *
 * Code sources/examples:
 * -crypto price/api: Cryptocurrency Pricing App, Bilguun Batbold, Medium
 *  https://medium.com/quick-code/build-a-simple-app-with-pull-to-refresh-and-favourites-using-flutter-77a899904e04
 * -"for each":
 *   //https://codingwithjoe.com/dart-fundamentals-working-with-lists/#looping
 * -decoding conversion rates
 *    https://lesterbotello.dev/2019/07/13/consuming-http-services-with-flutter/
 */

//main.dart

import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:flutter/material.dart';

void main() {
  //run: tabbedAppbar; display bottom bar
  runApp(BottomNavigation());
}

