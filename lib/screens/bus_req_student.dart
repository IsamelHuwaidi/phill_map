import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phill_map/utl/constant_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class BusReqStudent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BusReqStudentState();
  }
}

class BusReqStudentState extends State<BusReqStudent> {
  String lang = '';
  String Id_user = '';
  String Id_bus_request = '';
  List<Marker> markers = [];
  late Timer timer;
  bool canShowDialog = true;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  checkLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;
    Id_user = preferences.getString(ConstantValue.Id_user) ?? '';
    getCurrentLocation();
    timer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) => getUsrBusReq());
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {})
        .catchError((e) {});
  }

  @override
  void initState() {
    super.initState();
    checkLang();
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




  Future getUsrBusReq() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getUsrBusReq.php"),
        body: {'Id_users': Id_user});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      String result = jsonBody['result'];
      if (result == '1') {
        String type = jsonBody['type'];
        Id_bus_request = jsonBody['Id_bus_request'];
        if (type == '2') {
          if (canShowDialog) {
            canShowDialog = false;
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.waiting),
                  content: Text(AppLocalizations.of(context)!
                      .we_are_working_to_find_a_bus_for_you),
                  actions: <Widget>[
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.ok),
                      onPressed: () {
                        canShowDialog = true;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          if (markers.isEmpty) {
            markers.add(Marker(
              markerId: MarkerId(jsonBody['Name']),
              position: LatLng(double.parse(jsonBody['Latitude']),
                  double.parse(jsonBody['Longitude'])),
              infoWindow: InfoWindow(
                title: jsonBody['Name'],
                onTap: () {},
              ),
              icon: BitmapDescriptor.fromBytes(
                  await getBytesFromAsset('assets/images/bus_icon.jpg', 60)),
            ));
          } else {
            markers[0] = Marker(
              markerId: MarkerId(jsonBody['Name']),
              position: LatLng(double.parse(jsonBody['Latitude']),
                  double.parse(jsonBody['Longitude'])),
              infoWindow: InfoWindow(
                title: jsonBody['Name'],
                onTap: () {},
              ),
              icon: BitmapDescriptor.fromBytes(
                  await getBytesFromAsset('assets/images/bus_icon.jpg', 30)),
            );
          }
        }
      }
    }
    setState(() {});
  }

  Future cancel() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "cancelBusReq.php"),
        body: {'Id': Id_bus_request});
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.send_bus_request,
            style: TextStyle(color:  Color.fromRGBO(50, 49, 140, 1),
              fontSize: 25,
              fontStyle: FontStyle.italic,
            )
        ),

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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(50, 10, 50, 10),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(50, 49, 140, 1),
            borderRadius: BorderRadius.circular(0)),
        child: TextButton(
          onPressed: () {
            cancel();
          },
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
