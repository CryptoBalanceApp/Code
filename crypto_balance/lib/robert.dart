_buildShortList(),
onRefresh: getPricesAPI,


//
  void _selectedCurrency(Currency currAbbrev) {
    setState(() {
      currencySelection = currAbbrev.current.toString();

      //runApp(MyApp());
      //PricesList();
      print("selected currency is " + currencySelection);
      print("selected currency price is" );

    });
  }


//to put in refresh indicator
<Widget>[
new PopupMenuButton(
  itemBuilder: (BuildContext context){
    return Currencies.map((Currency currencie){
      //on select: command to make change when dropdown menu selected
      return new PopupMenuItem(
        value: currencie,
        child: new ListTile(title: currencie.current, ),
      );
    }).toList();
    //onSelected:
  },
  onSelected: _selectedCurrency,
  color: Colors.white, icon: Icon(Icons.more_vert,color: Color(0xff3E0CA9), ),
),
],