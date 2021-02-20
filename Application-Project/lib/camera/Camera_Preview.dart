
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsearch/screen/add_place_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class PreviewImageScreen extends StatefulWidget {
  final LatLng position;
  final String imagePath;
  final String now;
  final String placeName;
  PreviewImageScreen({this.imagePath, this.position, this.now , this.placeName});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  final _fireStore = Firestore.instance;
  final fireDatabase = FirebaseDatabase.instance.reference();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check , color: Colors.white, size: 25,),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddPlaceScreen(position: widget.position , placeName: widget.placeName,now: widget.now, pickedImagePath: widget.imagePath,)));
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child:
                        Image.file(File(widget.imagePath), fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imagePath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
