import 'dart:ui';

import 'package:flutter/material.dart';

class BottomSheetPage extends StatelessWidget {
  final String placeName;
  final String imageUrl;
  final String description;
  BottomSheetPage({this.placeName , this.imageUrl , this.description});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xff757575),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(20.0),),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0 , right: 20.0 , top: 10.0),
                child: Text(placeName , style: TextStyle(fontSize: 17,),textAlign: TextAlign.center,),
              ),
              SizedBox(
                height: 15,
              ),
              Image.network(imageUrl , fit: BoxFit.cover,height: 400, width: double.infinity,),
              SizedBox(
                height: 13,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0 , right: 20.0),
                child: Text(description , style: TextStyle(fontSize: 15,),textAlign: TextAlign.center,),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),

        ),
      ),
    );
  }
}

