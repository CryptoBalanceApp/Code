

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp3());

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('References', style: TextStyle(color: Color(0xff3E0CA9),
                fontSize: 20.0,
                fontFamily: 'Josefin Sans'),),

          ),
          body: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _buildReferenceCard("Cryptocurrency Pricing App",
                      "Assets/Icons/icons8-medium-50.png", "yooo")
                ],

              ),

            ],

          )
          ,
        )

    );
  }

  Widget _buildReferenceCard(String title, String icon, String link) {
    return Stack(
      children: <Widget>[
        Container(
          width: 175,
          height:250,
          //color: Colors.white,
          decoration: BoxDecoration(


            border:Border.all(color: Colors.black,width: 3.0),
            color: Color(0xff3E0CA9).withOpacity(0.5),

            //gradient:LinearGradient(colors: [Color(0xff3E0CA9),Colors.black87],
          )
          ,

        ),




        Positioned(
          left: 62.5,
          top: 80,
          child:Image.asset(icon),
        ),
        Positioned(
            left:0,
            right: 0,
            bottom: 0,
            child: Card(
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black87)  , ),
                color: Color(0xff3E0CA9).withOpacity(0.15),

                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(title,style: TextStyle(fontSize: 20,color: Colors.black,fontFamily: 'Josefin Sans'),),
                )
            )
        )
      ],
    );

  }
}