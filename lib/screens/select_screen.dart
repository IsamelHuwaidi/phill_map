import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phill_map/main.dart';
import 'package:phill_map/screens/bus_req_student.dart';
import 'package:phill_map/screens/faq_screen.dart';
import 'package:phill_map/screens/main_screen.dart';
import 'package:phill_map/screens/search_screen.dart';
import 'package:phill_map/screens/splash_screen.dart';
import 'package:phill_map/utl/constant_value.dart';
import 'package:phill_map/utl/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/bus_stops.dart';

class SelectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectScreenState();
  }
}

class SelectScreenState extends State<SelectScreen> {
  String lang = '';
  String IdBusStop = '1';
  String Id_user = '';
  String result = '';
  late Timer timer;
  List<BusStops> listBusStop = [];

  checkLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;
    Id_user = preferences.getString(ConstantValue.Id_user) ?? '';
    timer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) => getUsrBusReq());
    getBusStops();
  }

  Future getUsrBusReq() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "getUsrBusReq.php"),
        body: {'Id_users': Id_user});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      result = jsonBody['result'];
    }
  }

  Future sendBusRequest() async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "sendBusRequest.php"),
        body: {'lang': lang, 'Id_busstops': IdBusStop, 'Id_user': Id_user});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var result = jsonBody['result'];
      if (result == '1') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(jsonBody['msg']),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusReqStudent()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    }
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
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getUsrBusReq();
    checkLang();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.what_are_you_looking_for,
              style: TextStyle(color: Colors.white,
                  fontSize: 25,
                fontStyle: FontStyle.italic,
              )),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromRGBO(50, 49, 140, 1),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Color.fromRGBO(50, 49, 140, 1),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Image.asset(
              'assets/images/background_4.jpg',
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width/0.5,
              height: MediaQuery.of(context).size.height/1.12,

            ),
            Column(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 226, 255, 25),
                      borderRadius: BorderRadius.circular(35)),
                  margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen("1")),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.colleges,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                  color: Color.fromRGBO(43, 59, 127, 1),
                              ),
                            ),
                            width:
                                (MediaQuery.of(context).size.width - 250) * .75,
                          ),
                          SizedBox(
                            child: Icon(
                              Icons.school,
                                color: Color.fromRGBO(43, 59, 127, 1),
                            ),
                            width:
                                (MediaQuery.of(context).size.width - 150) * .25,
                          )
                        ],
                      )),
                ),

                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 226, 255, 25),
                      borderRadius: BorderRadius.circular(35)),
                  margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen("2")),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.bus_stops,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                color: Color.fromRGBO(43, 59, 127, 1),
                              ),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 200) * .75,
                          ),
                          SizedBox(
                            child: Icon(
                              Icons.location_on,
                              color: Color.fromRGBO(43, 59, 127, 1),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 60) * .25,
                          )
                        ],
                      )),
                ),

                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 226, 255, 17),
                      borderRadius: BorderRadius.circular(35)),
                  margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen("3")),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.other_facilities,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic ,
                                fontSize: 20,
                                color: Color.fromRGBO(43, 59, 127, 1),
                              ),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 200) * .75,
                          ),
                          SizedBox(
                            child: Icon(
                              Icons.apartment,
                              color: Color.fromRGBO(43, 59, 127, 1),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 60) * .25,
                          )
                        ],
                      )),
                ),

                Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 226, 255, 17),
                      borderRadius: BorderRadius.circular(35)),
                  child: InkWell(

                      onTap: () {
                        if (result == '0') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)!
                                    .send_bus_request),
                                content: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 15,
                                        bottom: 0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  50, 49, 140, 1)),
                                        ),
                                        disabledBorder:
                                            const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  50, 49, 140, 1)),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                  50, 49, 140, 1)),
                                        ),
                                        labelText: AppLocalizations.of(context)!
                                            .select_bus_stop,
                                      ),
                                      value: IdBusStop,
                                      items: listBusStop.map((BusStops items) {
                                        return DropdownMenuItem(
                                          value: items.Id,
                                          child: SizedBox(
                                            child: Text(
                                              items.Name,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          IdBusStop = newValue!;
                                        });
                                      },
                                    )),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.send),
                                    onPressed: () {
                                      sendBusRequest();
                                      Navigator.pop(context);

                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BusReqStudent()),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.send_bus_request,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                color: Color.fromRGBO(43, 59, 127, 1),
                              ),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 240) * .75,
                          ),
                          SizedBox(
                            child: Icon(
                              Icons.bus_alert,
                              color: Color.fromRGBO(43, 59, 127, 1),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 100) * .25,
                          )
                        ],
                      )),
                ),

                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 226, 255, 17),
                      borderRadius: BorderRadius.circular(35)),
                  margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.search,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                color: Color.fromRGBO(43, 59, 127, 1),
                              ),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 250) * .75,
                          ),
                          SizedBox(
                            child: Icon(
                              Icons.search,
                              color: Color.fromRGBO(43, 59, 127, 1),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 110) * .25,
                          )
                        ],
                      )),
                ),

                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 226, 255, 17),
                      borderRadius: BorderRadius.circular(35)),
                  margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FaqScreen()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.faq,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(43, 59, 127, 1),
                              ),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 260) * .75,
                          ),
                          SizedBox(
                            child: Icon(
                              Icons.campaign_outlined,
                              color: Color.fromRGBO(43, 59, 127, 1),
                            ),
                            width:
                            (MediaQuery.of(context).size.width - 100) * .25,
                          )
                        ],
                      )),
                ),

                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 226, 255, 17),
                      borderRadius: BorderRadius.circular(35)),
                  margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  child: InkWell(
                    onTap: () {
                      if (lang == ConstantValue.en) {
                        General.savePrefString(
                            ConstantValue.lang, ConstantValue.ar);
                        MyApp.of(context)?.setLocale(
                            Locale.fromSubtags(languageCode: ConstantValue.ar));
                      } else {
                        General.savePrefString(
                            ConstantValue.lang, ConstantValue.en);
                        MyApp.of(context)?.setLocale(
                            Locale.fromSubtags(languageCode: ConstantValue.en));
                      }
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const SplashScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          child: Text(
                            AppLocalizations.of(context)!.language,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                              color: Color.fromRGBO(43, 59, 127, 1),
                            ),
                          ),
                          width:
                          (MediaQuery.of(context).size.width - 250) * .75,
                        ),
                        SizedBox(
                          child: Icon(
                            Icons.language,
                            color: Color.fromRGBO(43, 59, 127, 1),
                          ),
                          width:
                          (MediaQuery.of(context).size.width - 120) * .25,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        )));
  }
}
