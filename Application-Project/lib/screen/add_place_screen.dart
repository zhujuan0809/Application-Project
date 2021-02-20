import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsearch/screen/HomePage.dart';
import '../widget/ImageInput.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:geocoder/geocoder.dart';
class AddPlaceScreen extends StatefulWidget {
  final String placeName;
  final LatLng position;
  final String pickedImagePath;
  final String now;
  AddPlaceScreen({this.placeName , this.position , this.pickedImagePath , this.now});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  final _placeNameController = TextEditingController();
  Address first;

  Future<void> _uploadData(BuildContext context) async
  {
    if(widget.pickedImagePath == null || _descriptionController == null){
      return;
    }
    setState(() {
      _isLoading = true;
    });
    var myFile = File(widget.pickedImagePath);
    String fileName = basename(widget.pickedImagePath);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(myFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print('picture uploaded');
    });
    final ref = FirebaseStorage.instance.ref().child('${widget.now}.png');
    var url1 = await ref.getDownloadURL() as String;
    print(url1);
    const url = 'https://mapsearch-a3c96.firebaseio.com/location.json';
    http.post(url , body: json.encode({
      'latitude' : widget.position.latitude,
      'longitude' : widget.position.longitude,
      'imagePath' : url1,
      'description': _descriptionController.text,
      'placename' : widget.placeName,
    })).then((_){
      setState(() {
        _isLoading = false;
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MyHomePage()));
      });
    });
  }
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
      final coordinates = new Coordinates(widget.position.latitude , widget.position.longitude);
       var address = await Geocoder.google('AIzaSyDoA0-q0UxChFxGpVCIPdAiyshlRjxcT-M').findAddressesFromCoordinates(coordinates);
       first = address.first;
      setState(() {
        print(first.featureName);
        _placeNameController.text = first.featureName;
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          :Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Place Name'),
                      enabled: false,
                      controller: _placeNameController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(widget.placeName , widget.position),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'description'),
                      controller: _descriptionController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            onPressed: (){
              _uploadData(context);
            },
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
