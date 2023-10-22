import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utl/constant_value.dart';

class ForgotPasswordScreen extends StatefulWidget {
  String email = '';

  ForgotPasswordScreen(this.email);

  @override
  createState() => ForgotPasswordScreenState(email);
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';
  String lang = '';
  TextEditingController passwordController = TextEditingController();
  
  ForgotPasswordScreenState(this.email);

  checkLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15, bottom: 0),
          child: TextField(
            controller: passwordController,
            cursorColor: const Color.fromRGBO(79, 98, 240, 1),
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
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
                labelText: AppLocalizations.of(context)!.password,
                hintText: AppLocalizations.of(context)!.enter_your_password),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(79, 98, 240, 1),
            borderRadius: BorderRadius.circular(0)),
        child: TextButton(
          onPressed: () {
            updatePassword();
          },
          child: Text(
            AppLocalizations.of(context)!.update_password,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }

  Future updatePassword() async {
    final response = await http.post(
      Uri.parse(ConstantValue.URL + "updatePassword.php"),
      body: {
        'Email': email,
        'Password': passwordController.text,
        'lang': lang,
      },
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      String result = jsonBody['result']; // get data from json
      if (result == '1') {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title:  Text(AppLocalizations.of(context)!.wrong),
              content: Text(jsonBody['msg']),
              actions: <Widget>[
                TextButton(
                  child:  Text(AppLocalizations.of(context)!.ok),
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
}
