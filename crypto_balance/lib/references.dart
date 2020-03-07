import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:crypto_balance/main.dart';
import 'package:crypto_balance/tabbedAppbar.dart';
import 'package:crypto_balance/entities/factors.dart';
import 'package:crypto_balance/referencesTab.dart';


void main() => runApp(MyApp2());

class MyApp2 extends StatelessWidget {
  @override



  Widget build(BuildContext context) {
    void pushRefTab(){
      print("pushRefTab entered");
      /*Navigator.of(context).push(
        new MaterialPageRoute<void>(
          MyApp3,
        ),
      );*/
    }
    return MaterialApp(
      home: Scaffold(
          /*appBar: AppBar(
            title: Text('About Page',style: TextStyle(color:Color(0xff3E0CA9), fontFamily: 'Josefin Sans')),
            backgroundColor: Colors.white,
          ),*/

          body: SingleChildScrollView(child:Column(
              children: <Widget>[

                Center(child:
                Image.asset('Assets/Logos/moneyTreeAndroid.png',fit: BoxFit.contain,
                    height: 153, width: 140),),

                Center(child:Text('CRYPTO BALANCE',style: TextStyle(color:Color(0xff3E0CA9),
                    fontFamily:'Josefin Sans', fontSize:30.0 )
                ),),

                Center(child: Container(  margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),child: Text('CryptoBalance app is our project to enhance investor knowledge and efficiency across multiple micro-investing apps.',
                        textAlign:TextAlign.center,style: TextStyle(color:Colors.black,fontFamily:'Josefin Sans', height:2.0,fontSize: 15.0, fontStyle: FontStyle.italic  )
                    )
                )),

                Center(child:
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,25,10,10),
                  child: Text('Contributors', style: TextStyle(color:Colors.black,fontFamily:'Josefin Sans', fontSize: 27.0)),
                )),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child:
                  _profile('Robert Silver', 'Project Leader, UI, Back End', 'Assets/Photos/truthPoints.jpg')),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child:
                  _profile('Jerid Roberson', 'Project Leader, UI, Back End', 'Assets/Photos/30for30LAV.jpg')),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child:
                  _profile('Mike Perez', 'Project Leader, UI, Back End', 'Assets/Photos/gamer1.jpeg')),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: ListTile.divideTiles(context: context,
                      tiles:[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: ListTile(
                              title: Text("Version 1.0",style: TextStyle(color:Color(0xff3E0CA9),
                                  fontFamily:'Josefin Sans', fontSize:20.0 )),
                              dense:true
                          ),

                        ),

                        ListTile(title: Text("References",style: TextStyle(color:Color(0xff3E0CA9),
                            fontFamily:'Josefin Sans', fontSize:20.0 )),
                          dense:true,
                          trailing: Icon(Icons.arrow_forward),
                          onTap: (){
                            print("testing push button");
                            pushRefTab();
                          },
                        ),

                        ListTile(title: Text("Legal",style: TextStyle(color:Color(0xff3E0CA9),
                            fontFamily:'Josefin Sans', fontSize:20.0 )),
                            dense:true),
                      ]
                  ).toList(),
                )
              ]
          )
          )
      ),
    );


  }



  Widget _profile(String name, String roles, String imagePath ){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 190.0,
          height: 190.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(imagePath)

              )
          ),

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name, style: TextStyle(color:Colors.grey,fontFamily:'Josefin Sans', fontSize: 20.0 )),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(roles, style: TextStyle(color:Colors.grey,fontFamily:'Josefin Sans', fontSize: 20.0 )),
        )
      ],
    );
  }
}