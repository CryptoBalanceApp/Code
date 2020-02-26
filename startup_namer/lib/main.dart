// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
/*
 * Material: visual design language; flutter
 * has built in widgets
 */
void main() => runApp(MyApp());
/*
 *Arrow notation: used for one-line functions
 * or methods
 */

class MyApp extends StatelessWidget {
  /*
   *App extends StatelessWidget, makes app
   * a widget. Almost everything a widget, including
   * alignment, padding, layout
   *
   *
   */
  @override
  Widget build(BuildContext context){
    /* Widget: main purpose: provide
     * build() method: describe how to
     * display widget in terms other,
     * lower level widgets
     */
    //final wordPair = WordPair.random();
    return MaterialApp(
      /*title: 'Welcome to Flutter',
      home: Scaffold(*/
      title: 'Startup Name Generator',
      // edit default them to change theme of app
      theme: ThemeData(
        /*ThemeData: class, material library, color and typography values,
         *Material design theme... access through builder, widget context (theme
         * data of ancestor classes
         */
        primaryColor: Colors.white,
        dividerColor: Colors.blueAccent,
        backgroundColor: Colors.orange[200],
      ),
      home: RandomWords(),
        /* Scaffold: widget from material library
         * provides default app bar, title, and
         * body property
         * body: holds widget tree, home screen
         */
        /*appBar: AppBar(
          title: Text('Welcome to FLutter'),
        ),
        body: Center(
          /* Center: aligns widget subtree
           * to center of screen (children)
           */
          //child: Text(wordPair.asPascalCase),
          //PascalCase: UpperCamelCase
          child: RandomWords(),
        ),
      ),*/
    );
  }
}

/* States:
 * Stateless widgets: immutable: properties can't change, all values final
 * Stateful: maintain state: might change during lifetime of the widget;
 * requires two classes to be implemented:
 *   -StatefulWidget (immutable) class: Creates instance of...
 *   -State class: persists over lifetime of widget
 *
 * Next Step:
 * Add stateful widget, RandomWords
 *  -Child inside MyApp stateless widget
 *  -Creates State class, RandomWordsState
 */

class RandomWords extends StatefulWidget{
  /* RandomWords: stateful widget for RandomWordsState; mostly just create its
   * state class
   */
  @override
  /* @override: marks instance member as overriding a superclass member with
   * same name. Mainly: use methods: superclass out of programmer's control;
   * i.e. in different package
   * optional
   */
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{
  /* Declaration: State<RandomWords>
   *  -generic State<> class: specialized for use with "RandomWords"
   *  -app logic and state resides here: maintains state, RandomWords widget
   *  -Basic logic:
   *     --Save generated word pairs, grow infinitely
   *     --favorite word pairs: heart icon, user add/remove
   *  -RandomWordsState depends on RandomWord class (implemented later)
   */
  @override
  /* Need to now add build method:
   *   -generates word pairs: moving code from MyApp to here
   */
  final _suggestions = <WordPair>[];
  //suggestions: saving suggested word pairs generated in a infinite list
  // underscore before variable (_x) denotes privacy
  final _biggerFont = const TextStyle(fontSize: 18.0);
  //bigger font: variable, make font 18 point
  final Set<WordPair> _saved = Set<WordPair>();
  /* Set of saved word pairings, favorited; Set: should not allow duplicate
   * entries, while list would allow duplicate entries
   */


  /*builder: display actual content, on screen
   *Widget tree: all the widgets in the app, hierarchical, their current states
   * builder class: set of methods use from stateless widget build method and
   * from state objects
   * build context: passed into the builder; context of widget objects, parents
   * or ancestors; inheritance of built-in-object features? where you are in
   * widget tree... widget inherits properties from parents; leave unchanged
   * for this app I belive (just "context")
   */
  //note: navigator manages routes for flutter apps; new route pushed to app,
  //new route displayed. popped, go back old display
  Widget build(BuildContext context) {
    /*final wordPair = WordPair.random();
    return Text(wordPair.asPascalCase); */
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        //add list icon: on click, new route pushed to stack
        actions: <Widget>[
          //<Widget>[]: way for widget: have multiple children? action: takes
          //array of widgets as children; widget property actions
            //iconbutton: material library: class, display icons, clickable
            //this icon: on push: go to pushshaved,
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],

      ),
      body: _buildSuggestions(),
    );

  }

  void _pushSaved(){
    /* now, build route: push to navigator stack (change screen display to
     * saved pairs screen).
     */
    Navigator.of(context).push(
      /*Add MaterialPageRoute and builder: route to replace entire screen;
       * type of transistion depends on OS, by default maintainState positive:
       * previous route maintained in memory
       *type T: specify return type of route; return is supplied to first route
       * when new route popped off of navigator stack
       */
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //map: key.value pairs; creating map?
          //generate listTile rows; iterable: list that can be iteraded over
          //using map from saved as iterable? puting in options for map?
          //making an iterable of "listtiles" (same tile used before)
          final Iterable<ListTile> tiles = _saved.map(
            //for each wordpair in set, return a ListTile with properties
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          //make a list widget to display iterable ListTile of saved pairs
          final List<Widget> divided = ListTile
            //dividetiles: built in ListTile method, add horizontal space
            .divideTiles(
              context: context,
              //tiles: iterable made above
              tiles: tiles,
            )
            //convert final listtiles+space into list, .toList
            .toList();
          /*want builder to return scaffold, w/ app bar, named saved sugg.s
          and body of new route: listview, contain listtile rows and seperators
          we want a listview to fit into the scaffold build in listview
          */
          //similar to making first scaffold for main route body
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions(){
    /* build suggestions for infinite scrolling list
     * Listview widget: builder: factory constructor, lists
     *  -itemBuilder: factory builder/callback
     *    -pass in BuildContext, row iterator i
     *    -iterator: begins at 0, incremements each time function called
     *    -increments twice each word pairing: once for ListTile, once for
     *     divider; allows list grow infinitely w/ scroll
     */
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i){
        /*itemBuilder: callback: called once per suggested pairing,
         * place each suggestion (context) into ListTile row (i)
         * Odd rows: add divider, visually seperate
         * ListTile: single fixed-height row: contains text w/ leading/
         * trailing icon i.e check box
         */
        if (i.isOdd) return Divider();
          //isOdd returns true if odd
          //all odd iterators: divider put in (between entries)
          //1 pixel high divider
          final index = i ~/ 2;
          //~/: truncate divide; like floor (drop fractional digits, int cast)
          if(index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
            /* If you've reached end of word pairing (index>=
             * _suggestions.length), generate 10 more and add them
             * to suggestions list
             */
          }
          return _buildRow(_suggestions[index]);

      }
    );
  }
  Widget _buildRow(WordPair pair){
    //first: check if pair already saved; check set already saved for pair
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        //next: create heart (trailing) icon; native part of a ListTile
        trailing: Icon(
          /*use ternary operator ?: <bool> ? <option1>:<option2>, if bool true,
           * use option 1, else use option 2
           */
          //note: 'favorite:' constant, material class: built in heart icon
          //first check if pair saved to determine icon, heart or line
          alreadySaved ? Icons.favorite: Icons.favorite_border,
          //next set color based on already saved or not; whether heart colored
          color: alreadySaved ? Colors.red :null,
        ),
        /*add icon interactivity: tap to heart favorite or unfavorite; checks if
         *already favorite via alreadySaved, updates to add/remove from savedSet
         */
        onTap: () {
          //set the state of the icon (i think)
          /*since we made ternary statements above just changing set alone will
            *handle formatting
           */
          setState(() {
            if(alreadySaved) {
              _saved.remove(pair);
            } else{
              _saved.add(pair);
            }
          });
        },
    );
  }
}



/*
 * Left off: step 4: Creating infinite scrolling listView, write app
 */