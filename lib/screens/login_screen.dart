import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:phill_map/screens/main_screen_driver.dart';
import 'package:phill_map/screens/select_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utl/constant_value.dart';
import '../utl/general.dart';
import 'forgot_password.dart';
import 'main_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController vervicationCodeController = TextEditingController();
  String lang = '';
  String Id_user = '';

  checkLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;
    Id_user = preferences.getString(ConstantValue.Id_user) ?? '';
    if (Id_user == '') {
      addUser();
    }
  }

  @override
  void initState() {
    super.initState();
    checkLang();
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
        centerTitle: true,
        title: const Text(
          "Phill Map",
          style: TextStyle(color: Color.fromRGBO(43, 59, 127, 1), fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                cursorColor: const Color.fromRGBO(79, 98, 240, 1),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(79, 98, 240, 1)),
                      //suffixIcon: Icon(Icons.email),
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
                    labelText: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.enter_your_email),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: passwordController,
                cursorColor: const Color.fromRGBO(79, 98, 240, 1),
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
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
                    hintText:
                        AppLocalizations.of(context)!.enter_your_password),
              ),
            ),
            TextButton(
              onPressed: () {
                sendemailForgetPassword();
              },
              child: Text(
                AppLocalizations.of(context)!.forgot_password,
                style: const TextStyle(
                    color: Color.fromRGBO(79, 98, 240, 1), fontSize: 15),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(50, 49, 140, 1),
                  borderRadius: BorderRadius.circular(35)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectScreen()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.student_or_guest,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(50, 49, 140, 1),
                  borderRadius: BorderRadius.circular(35)),
              child: TextButton(
                onPressed: () {
                  login();
                },
                child: Text(
                  AppLocalizations.of(context)!.login_as_driver,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addUser() async {
    final response =
        await http.post(Uri.parse(ConstantValue.URL + "addUser.php"));
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      String result = jsonBody['result']; // get data from json
      if (result == '1') {
        General.savePrefString(ConstantValue.Id_user, jsonBody['Id_user']);
      }
    }
  }

  Future login() async {
    final response = await http.post(
      Uri.parse(ConstantValue.URL + "login.php"),
      body: {
        'Email': emailController.text,
        'Password': passwordController.text,
        'lang': lang,
      },
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      String result = jsonBody['result']; // get data from json
      if (result == '1') {
        General.savePrefString(ConstantValue.Id_driver, jsonBody['Id']);
        General.savePrefString(ConstantValue.Name, jsonBody['Name']);
        General.savePrefString(ConstantValue.Email, jsonBody['Email']);
        General.savePrefString(ConstantValue.Phone, jsonBody['Phone']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainScreenDriver()),
        );
      } else {
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

  Future sendemailForgetPassword() async {
    final response = await http.post(
      Uri.parse(ConstantValue.URL + "sendemailForgetPassword.php"),
      body: {'Email': emailController.text, 'lang': lang},
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      String result = jsonBody['result']; // get data from json
      if (result == '1') {
        vervicationCodeAlertDialog(jsonBody['msg'], context);
      } else {
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

  Future<void> vervicationCodeAlertDialog(int msg, BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    if (vervicationCodeController.text == msg.toString()) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ForgotPasswordScreen(emailController.text)),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.ok))
            ],
            title: Text(
                AppLocalizations.of(context)!.enter_the_msg_send_to_your_email),
            content: TextField(
              onChanged: (value) {},
              controller: vervicationCodeController,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!
                      .enter_the_msg_send_to_your_email),
            ),
          );
        });
  }
}
