import 'package:flutter/material.dart';

//set up string names
const String currUSD = "USD";
const String currJPY = "JPY";
const String currGBP = "GBP";
const String currMXN = "MXN";
const String currZAR = "ZAR";
const String currCNY = "CNY";
const String currEUR = "EUR";
const String currKRW = "KRW";
const String currINR = "INR";
const String currTHB = "THB";
const String currPHP = "PHP";

class Currency{
  final Text current;
  final String acronym;
  const Currency({
    this.current,
    this.acronym,
  });
}

const List<Currency> Currencies = <Currency>[
  const Currency(
    current: const Text('USD',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currUSD,
  ),
  const Currency(
    current: const Text('YEN',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currJPY,
  ),
  const Currency(
    current: const Text('Pound',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currGBP,
  ),
  const Currency(
    current: const Text('Peso',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currMXN,
  ),
  const Currency(
    current: const Text('Rand',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currZAR,
  ),
  const Currency(
    current: const Text('Rupee',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currINR,
  ),
  const Currency(
    current: const Text('Yaun',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currCNY,
  ),
  const Currency(
    current: const Text('Euro',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currEUR,
  ),
  const Currency(
    current: const Text('Won',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currKRW,
  ),
  const Currency(
    current: const Text('Baht',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currTHB,
  ),
  const Currency(
    current: const Text('Philippine',style: TextStyle(color: Color(0xff3E0CA9)),),
    acronym: currPHP,
  ),

];