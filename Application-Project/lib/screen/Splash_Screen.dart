
import 'package:flutter/material.dart';
import 'package:mapsearch/screen/HomePage.dart';
import './Login_Page.dart';

class SplashScreens extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MyHomePage();
                },
              ),
            );
          },
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Image.asset('images/Intro.jpeg'),
                Positioned(
                  bottom: 240,
                  left: 100,
                  child: Text('Tap Anywhere to Continue' , style: TextStyle(color: Colors.grey , fontSize: 12 , decoration: TextDecoration.none),),
                ),

              ],
            ),
          )
      ),
    );
  }
}
