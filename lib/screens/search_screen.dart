import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:phill_map/models/search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utl/constant_value.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  List<SearchModel> listSearchModel = [];
  TextEditingController searchTextEditingController = TextEditingController();

  String lang = '';
  checkLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: TextField(
            onSubmitted: (value) {
              search(searchTextEditingController.text);
            },
            controller: searchTextEditingController,
            textAlign: TextAlign.center,
            cursorColor: const Color.fromRGBO(79, 98, 240, 1),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchTextEditingController.text = '';
                  },
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1, color: Color.fromRGBO(79, 98, 240, 1)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1, color: Color.fromRGBO(79, 98, 240, 1)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1, color: Color.fromRGBO(79, 98, 240, 1)),
                ),
                hintText: AppLocalizations.of(context)!.search),
          ),
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (listSearchModel[index].Type == '1') {
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
                      AppLocalizations.of(context)!.bus_stop_name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      listSearchModel[index].Name,
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
                          navigateTo(
                              double.parse(listSearchModel[index].Latitude),
                              double.parse(listSearchModel[index].Longitude));
                        },
                        icon: const Icon(Icons.directions))
                  ],
                )
              ]),
            );
          } else if (listSearchModel[index].Type == '2') {
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
                      AppLocalizations.of(context)!.college_name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      listSearchModel[index].Name,
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
                          navigateTo(
                              double.parse(listSearchModel[index].Latitude),
                              double.parse(listSearchModel[index].Longitude));
                        },
                        icon: const Icon(Icons.directions))
                  ],
                )
              ]),
            );
          } else if (listSearchModel[index].Type == '3') {
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
                      AppLocalizations.of(context)!.college_name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      listSearchModel[index].CollegeName,
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
                      listSearchModel[index].Floor,
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
                      AppLocalizations.of(context)!.hall_number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      listSearchModel[index].Name,
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
                          navigateTo(
                              double.parse(listSearchModel[index].Latitude),
                              double.parse(listSearchModel[index].Longitude));
                        },
                        icon: const Icon(Icons.directions))
                  ],
                )
              ]),
            );
          } else {
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
                      AppLocalizations.of(context)!.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      listSearchModel[index].Name,
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
                          navigateTo(
                              double.parse(listSearchModel[index].Latitude),
                              double.parse(listSearchModel[index].Longitude));
                        },
                        icon: const Icon(Icons.directions))
                  ],
                )
              ]),
            );
          }
        },
        itemCount: listSearchModel.length,
      ),
    );
  }

  Future search(String text) async {
    final response = await http.post(
        Uri.parse(ConstantValue.URL + "search.php"),
        body: {'text': text, 'lang': lang});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var busstops = jsonBody['busstops'];
      var colleges = jsonBody['colleges'];
      var collegeshalls = jsonBody['collegeshalls'];
      var otherfacilities = jsonBody['otherfacilities'];

      for (Map i in busstops) {
        listSearchModel.add(SearchModel.fromJson(i));
      }
      for (Map i in colleges) {
        listSearchModel.add(SearchModel.fromJson(i));
      }
      for (Map i in collegeshalls) {
        listSearchModel.add(SearchModel.fromJson(i));
      }
      for (Map i in otherfacilities) {
        listSearchModel.add(SearchModel.fromJson(i));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    checkLang();
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
