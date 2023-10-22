import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:phill_map/main.dart';
import 'package:phill_map/models/bus_stops.dart';
import 'package:phill_map/screens/bus_req_student.dart';
import 'package:phill_map/screens/halls_screen.dart';
import 'package:phill_map/screens/search_screen.dart';
import 'package:phill_map/screens/splash_screen.dart';
import 'package:phill_map/utl/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utl/constant_value.dart';

class MainScreen extends StatefulWidget {
  String type = '';

  MainScreen(this.type);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState(type);
  }
}

class MainScreenState extends State<MainScreen> {
  String type = '';

  MainScreenState(this.type);

  List<Marker> markers = [];
  List<BusStops> listBusStop = [];

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String lang = '';
  String IdBusStop = '1';
  String Id_user = '';
  String result = '';

  checkLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;
    Id_user = preferences.getString(ConstantValue.Id_user) ?? '';
    getCurrentLocation();
    if (type == '1') {
      getColleges();
    } else if (type == '2') {
      getBusStops();
    } else {
      getOtherFacilities();
    }
  }

  @override
  void initState() {
    super.initState();
    checkLang();
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {})
        .catchError((e) {});
  }

  Future getColleges() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getColleges.php"),
        body: {'lang': lang});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var colleges = jsonBody['colleges'];
      for (Map ii in colleges) {
        BitmapDescriptor icon;
        if (ii['Id'] == '2') {
          icon = BitmapDescriptor.fromBytes(
              await getBytesFromAsset('assets/images/iT_college_icon.png', 70));
        } else if (ii['Id'] == '3') {
          icon = BitmapDescriptor.fromBytes(
              await getBytesFromAsset('assets/images/nursing_college_icon.jpg', 70));
        } else {
          icon = BitmapDescriptor.fromBytes(
              await getBytesFromAsset('assets/images/business_college_icon.jpg', 70));
        }
        markers.add(Marker(
            markerId: MarkerId(ii['Name']),
            position: LatLng(
                double.parse(ii['Latitude']), double.parse(ii['Longitude'])),
            infoWindow: InfoWindow(
              title: ii['Name'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HallsScreen(ii['Id'], ii['Name'],
                          ii['Latitude'], ii['Longitude'])),
                );
              },
            ),
            icon: icon));
      }
    }

    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future getBusStops() async {
    listBusStop = [];
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getBusStops.php"),
        body: {'lang': lang});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var busstops = jsonBody['busstops'];
      for (Map i in busstops) {
        listBusStop.add(BusStops.fromJson(i));
        markers.add(Marker(
          markerId: MarkerId(i['Name']),
          position:
              LatLng(double.parse(i['Latitude']), double.parse(i['Longitude'])),
          infoWindow: InfoWindow(
            title: i['Name'],
            onTap: () {},
          ),
        ));
      }
    }
    setState(() {});
  }

  Future getOtherFacilities() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getOtherFacilities.php"),
        body: {'lang': lang});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var otherfacilities = jsonBody['otherfacilities'];
      for (Map i in otherfacilities) {
        markers.add(Marker(
          markerId: MarkerId(i['Name']),
          position:
              LatLng(double.parse(i['Latitude']), double.parse(i['Longitude'])),
          infoWindow: InfoWindow(
            title: i['Name'],
            onTap: () {},
          ),
        ));
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromRGBO(50, 49, 140, 1),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: markers.toSet(),
        initialCameraPosition: const CameraPosition(
            zoom: 15, target: LatLng(32.1648125, 35.8536262)),
      ),
    );
  }
}
