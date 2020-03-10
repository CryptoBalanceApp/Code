

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';


void main() => runApp(MyApp3());

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('References', style: TextStyle(color: Color(0xff3E0CA9),
            fontSize: 20.0,
            fontFamily: 'Josefin Sans'),),

      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 15, 15),
                    child: _buildReferenceCard("Cryptocurrency Pricing App",
                        "Assets/Icons/icons8-medium.svg", "https://medium.com/quick-code/build-a-simple-app-with-pull-to-refresh-and-favourites-using-flutter-77a899904e04"),
                  ),
                ),

                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 15, 15),
                      child: _buildReferenceCard("Flutter Crash Course YouTube",
                          "Assets/Icons/iconfinder_18-youtube_104482.svg", "https://www.youtube.com/channel/UCRCpzcQz-t2ueVihCIx5jDg"),
                    )
                ),

              ],
            ),
          ),

          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                    child: _buildReferenceCard("Udactiy Flutter Course",
                        "Assets/Icons/iconfinder_udacity_4691353.svg", "https://www.udacity.com/course/build-native-mobile-apps-with-flutter--ud905"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                    child: _buildReferenceCard("Flutter Documentation",
                        "Assets/Icons/iconfinder_flutter_4691465.svg", "https://flutter.dev/docs"),
                  ),
                ),

              ],

            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,20,8,0),
            child: Text("Click on a block to direct yourself to reference site",textAlign: TextAlign.center, style:TextStyle(fontSize: 20,color: Colors.black,fontFamily: 'Josefin Sans')),
          )

        ],

      ),
    );
  }

  Widget _buildReferenceCard(String title, String icon, String link) {
    return Stack(
      children: <Widget>[
        InkWell(child:
        Container(
          width: 175,
          height:250,
          //color: Colors.white,
          decoration: BoxDecoration(


            border:Border.all(color: Colors.black,width: 3.0),
            color: Color(0xff3E0CA9).withOpacity(0.5),

            //gradient:LinearGradient(colors: [Color(0xff3E0CA9),Colors.black87],
          ),

        ),
          onTap: (){
            _launchURL(link);

          },
        ),


        Positioned(
            left: 62.5,
            top: 80,
            child:SvgPicture.asset(icon,width: 50,height: 50)//Image.asset(icon),
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
  _launchURL(String link) async{
    String url = link;
    if(await canLaunch(url)){
      await launch(url);
    } else{
      throw 'Could not launch';
    }

  }
}