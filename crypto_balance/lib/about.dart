//about.dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:crypto_balance/referencesTab.dart';


void main() => runApp(AboutPage());


class AboutPage extends StatefulWidget {
  @override
  AboutHome createState() => AboutHome();

}

//class MyHome extends StatelessWidget{
class AboutHome extends State<AboutPage> with AutomaticKeepAliveClientMixin<AboutPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    //return new Scaffold(
    return new MaterialApp(
      home: Scaffold(

        appBar: new AppBar(
          title: new Text('About Page',style: TextStyle(color:Color(0xff3E0CA9), fontFamily: 'Josefin Sans')),
          backgroundColor: Colors.white,
        ),
        body:new SingleChildScrollView(child:Column(
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
                            title: Text("Version 1.1",style: TextStyle(color:Color(0xff3E0CA9),
                                fontFamily:'Josefin Sans', fontSize:20.0 )),
                            dense:true
                        ),

                      ),

                      ListTile(title: Text("References",style: TextStyle(color:Color(0xff3E0CA9),
                          fontFamily:'Josefin Sans', fontSize:20.0 )),
                        dense:true,
                        trailing: Icon(Icons.arrow_forward),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => new ReferencesPage()));

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
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
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