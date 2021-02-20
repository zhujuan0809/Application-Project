import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:mapsearch/BottomSheetPage.dart';
import 'package:mapsearch/screen/add_place_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng _lastPosition;
  TextEditingController locationController = TextEditingController();
  GoogleMapController mapController;
  Set<Marker> _maker = {};
  bool isLoading = false;
  bool isCurrentLocationLoading = false;
  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  searchNavigate() {
    Geolocator().placemarkFromAddress(locationController.text).then((result) {
      //move the map camera to search location
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15.0)));
    });
  }

  currentUserLocation() async
  {
    setState(() {
    });
    Position position =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    //List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude);
    print('Hello');
    setState(() {
      //move the camera to user current location
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude , position.longitude),
        zoom: 20.0,
      )));
      //locationController.text = placeMark[0].;
      final coordinates =
      Coordinates(position.latitude , position.longitude);
      Geocoder.local
          .findAddressesFromCoordinates(coordinates)
          .then((addresses) {
        locationController.text = addresses.first.addressLine;
      });
    });

  }

  _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void initState() {

    Future.delayed(Duration.zero).then((_) async {
      const url = 'https://mapsearch-a3c96.firebaseio.com/location.json';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((locationID, locationData) {
        print(locationID);
        _maker.add(
          Marker(
              markerId: MarkerId(locationID),
              position:
                  LatLng(locationData['latitude'], locationData['longitude']),
              infoWindow: InfoWindow(),
              icon: BitmapDescriptor.defaultMarker,
              onTap: () {
                print(locationData['description']);
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) => BottomSheetPage(
                    placeName: locationData['placename'],
                    imageUrl: locationData['imagePath'],
                    description: locationData['description'],
                  ),
                );
              }),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading || isCurrentLocationLoading
        ? Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white,),
          )
        : Scaffold(
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: onMapCreated,
                  markers: _maker,
                  initialCameraPosition: (CameraPosition(
                    target: LatLng(3.1390, 101.6869),
                    zoom: 15.0,
                  )),
                  onCameraMove: _onCameraMove,
                ),
                Positioned(
                  top: 40.0,
                  right: 60.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: 0.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: TextField(
                      onTap: ()async {
                        Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: 'AIzaSyDoA0-q0UxChFxGpVCIPdAiyshlRjxcT-M',
                            mode: Mode.fullscreen, // Mode.fullscreen
                            language: "en",
                            components: [
                              new Component(Component.country, "mys")
                            ]);
                        setState(() {
                          locationController.text = p.description;
                          print(locationController.text);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Location',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 5.0),
//                        suffixIcon: IconButton(
//                          icon: Icon(Icons.search),
//                          iconSize: 30.0,
//                          onPressed: searchNavigate,
//                        ),
                      ),
                      controller: locationController,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: IconButton(
                    iconSize: 40,
                    color: Colors.blueGrey,
                    icon: Icon(Icons.search),
                    onPressed: searchNavigate,
                  ),
                ),
                Positioned(
                  bottom: 50.0,
                  right: 15.0,
                  child: FloatingActionButton(
                    heroTag: 'btn2',
                    backgroundColor: Colors.lightBlueAccent,
                    child: Icon(
                      Icons.location_searching,
                      color: Colors.white,
                    ),
                    onPressed: currentUserLocation,
                  ),
                ),
                Positioned(
                  bottom: 120.0,
                  right: 15.0,
                  child: FloatingActionButton(
                    heroTag: 'btn1',
                    backgroundColor: Colors.lightBlueAccent,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => AddPlaceScreen(
                            placeName: locationController.text,
                            position: _lastPosition,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

//final coordinates =
//Coordinates(position.latitude , position.longitude);
//Geocoder.local
//    .findAddressesFromCoordinates(coordinates)
//.then((addresses) {
//locationController.text = addresses.first.addressLine;
//});