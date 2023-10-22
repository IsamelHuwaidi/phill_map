import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:phill_map/models/bus_stops.dart';
import 'package:phill_map/screens/halls_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utl/constant_value.dart';

class MainScreenDriver extends StatefulWidget {
  const MainScreenDriver({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreenDriverState();
  }
}

class MainScreenDriverState extends State<MainScreenDriver> {
  List<Marker> markers = [];
  String Id_driver = '';
  String lang = '';
  late Timer timer;
  bool canShowDialog = true;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late Position _currentPosition;
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    getBusStops();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Id_driver = preferences.getString(ConstantValue.Id_driver) ?? '';
    lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => getCurrentLocation());
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      updateDriversLocation();
    }).catchError((e) {});
  }

  Future updateDriversLocation() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "updateDriversLocation.php"),
        body: {
          'Id': Id_driver,
          'Longitude': _currentPosition.longitude.toString(),
          'Latitude': _currentPosition.latitude.toString()
        });
    if (response.statusCode == 200) {
      getBusRequest();
    }
  }

  Future getBusStops() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getBusStops.php"),
        body: {'lang': lang});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var busstops = jsonBody['busstops'];
      for (Map i in busstops) {
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

  Future getBusRequest() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getBusRequest.php"),
        body: {'lang': lang, 'Id_driver': Id_driver});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      String result = jsonBody['result'];
      if (result == '1') {
        String BusStopsName = jsonBody['busstopsName'];
        String Id_bus_request = jsonBody['Id_bus_request'];
        String Longitude = jsonBody['Longitude'];
        String Latitude = jsonBody['Latitude'];
        String type = jsonBody['type'];

        if (type == '1') {
          if (canShowDialog) {
            canShowDialog = false;
            showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: Container(
                    height: 120,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.direction_to +
                              BusStopsName),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(50, 49, 140, 1),
                                    borderRadius: BorderRadius.circular(0)),
                                child: TextButton(
                                  onPressed: () {
                                    canShowDialog = true;
                                    Navigator.pop(context);
                                    navigateTo(double.parse(Latitude),
                                        double.parse(Longitude));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .drive_to_location,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(50, 49, 140, 1),
                                    borderRadius: BorderRadius.circular(0)),
                                child: TextButton(
                                  onPressed: () {
                                    canShowDialog = true;
                                    arrived(Id_bus_request);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.i_arrived,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        } else {
          if (canShowDialog) {
            canShowDialog = false;
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: Container(
                    height: 120,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.bus_request_from +
                              BusStopsName),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(50, 10, 50, 10),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(13, 184, 25, 1),
                                    borderRadius: BorderRadius.circular(0)),
                                child: TextButton(
                                  onPressed: () {
                                    canShowDialog = true;
                                    Navigator.pop(context);
                                    accept(Id_bus_request);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.accept,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(50, 10, 50, 10),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(245, 20, 15, 1),
                                    borderRadius: BorderRadius.circular(0)),
                                child: TextButton(
                                  onPressed: () {
                                    canShowDialog = true;
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.reject,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      }
    }
  }

  Future accept(String Id_bus_request) async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "acceptBusReq.php"),
        body: {'Id': Id_bus_request, 'Id_driver': Id_driver, 'lang': lang});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      String result = jsonBody['result'];
      if (result == '0') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.wrong),
              content: Text(jsonBody['msg']),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future arrived(String Id_bus_request) async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "arrivedBusReq.php"),
        body: {'Id': Id_bus_request});
    if (response.statusCode == 200) {}
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

  void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
