import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phill_map/utl/constant_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SpalshScreenState();
  }
}

class SpalshScreenState extends State<SplashScreen> {
  checkLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String lang = preferences.getString(ConstantValue.lang) ?? ConstantValue.en;

    if (lang == 'en') {
      MyApp.of(context)
          ?.setLocale(Locale.fromSubtags(languageCode: ConstantValue.en));
    } else {
      MyApp.of(context)
          ?.setLocale(Locale.fromSubtags(languageCode: ConstantValue.ar));
    }

    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen())));
  }

  @override
  void initState() {
    super.initState();
    checkLang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
