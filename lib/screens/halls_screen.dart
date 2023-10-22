import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phill_map/models/colleges_halls.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utl/constant_value.dart';

class HallsScreen extends StatefulWidget {
  String CollegeId = '';
  String CollegeName = '';
  String CollegeLat = '';
  String CollegeLong = '';
  HallsScreen(
      this.CollegeId, this.CollegeName, this.CollegeLat, this.CollegeLong);
  @override
  State<StatefulWidget> createState() {
    return HallsScreenState(CollegeId, CollegeName, CollegeLat, CollegeLong);
  }
}

class HallsScreenState extends State<HallsScreen> {
  String CollegeId = '';
  String CollegeName = '';
  String CollegeLat = '';
  String CollegeLong = '';
  List<CollegesHalls> listCollegeHalls = [];

  HallsScreenState(
      this.CollegeId, this.CollegeName, this.CollegeLat, this.CollegeLong);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromRGBO(50, 49, 140, 1),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.halls_for + CollegeName,
          style: const TextStyle(
              color: Color.fromRGBO(43, 59, 127, 1), fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            color: Colors.white,
            child: Column(children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.hall_number,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    listCollegeHalls[index].Name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.floor,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    listCollegeHalls[index].Floor,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.directions,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        navigateTo(double.parse(CollegeLat),
                            double.parse(CollegeLong));
                      },
                      icon: const Icon(Icons.directions))
                ],
              )
            ]),
          );
        },
        itemCount: listCollegeHalls.length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getHalls();
  }

  void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  Future getHalls() async {
    listCollegeHalls = [];
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getHalls.php"),
        body: {"Id_colleges": CollegeId});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var collegeshalls = jsonBody['collegeshalls'];
      for (Map i in collegeshalls) {
        listCollegeHalls.add(CollegesHalls.fromJson(i));
      }
      setState(() {});
    }
  }
}
