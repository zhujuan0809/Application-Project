import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../camera/Camera_Screen.dart';
class ImageInput extends StatefulWidget {
  final String placeName;
  final LatLng position;
  ImageInput( this.placeName , this.position);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;



  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[

        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => CameraScreen(widget.placeName , widget.position),),);
            },
          ),
        ),
      ],
    );
  }
}
