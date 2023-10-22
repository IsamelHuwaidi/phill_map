import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.faq,
            style: TextStyle(color: Colors.white)),
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
              width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(226, 226, 255, 50),
                    borderRadius: BorderRadius.circular(35)),
              margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),

              child: InkWell(
                  onTap: () {
                    navigateTo(32.164060, 35.852830);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: Text(
                          AppLocalizations.of(context)!.feeling_sick,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(43, 59, 127, 1),
                          ),
                        ),
                        width:
                        (MediaQuery.of(context).size.width - 150) * .75,
                      ),
                      SizedBox(
                        child: Icon(
                          Icons.sick,
                          color: Color.fromRGBO(43, 59, 127, 1),
                        ),
                        width:
                        (MediaQuery.of(context).size.width - 200) * .25,
                      )
                    ],
                  ),
            )),

            SizedBox(height: 15),

            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(226, 226, 255, 50),
                  borderRadius: BorderRadius.circular(35)),
              margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: InkWell(

                onTap: () {
                  showDialog(context: context,
                      builder: (context)=>AlertDialog(
                        title: Text(AppLocalizations.of(context)!.alert),
                        content: Text(AppLocalizations.of(context)!.to_it_college),
                        actions: [
                          TextButton(onPressed: (){
                            navigateTo(32.1657831, 35.8518444);
                          },
                              child:Text(AppLocalizations.of(context)!.ok) ),

                          TextButton(onPressed: ()=> Navigator.pop(context),
                              child:Text(AppLocalizations.of(context)!.cancel)

                          )],

                      ),
                  );
                  // navigateTo(32.1657831, 35.8518444);
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                child: Text(
                  AppLocalizations.of(context)!.computer_level_exam,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(43, 59, 127, 1),
                  ),
                ),
                width:
                (MediaQuery.of(context).size.width - 150) * .75,
              ),
              SizedBox(
                child: Icon(
                  Icons.computer_sharp,
                  color: Color.fromRGBO(43, 59, 127, 1),
                ),
                width:
                (MediaQuery.of(context).size.width - 200) * .25,
              )
            ],
          )),


            ),

            SizedBox(height: 15),

            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(226, 226, 255, 50),
                  borderRadius: BorderRadius.circular(35)),
              margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),

              child: InkWell(
                  onTap: () {
                    navigateTo(32.166230, 35.851104);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: Text(
                          AppLocalizations.of(context)!.reading_time,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(43, 59, 127, 1),
                          ),
                        ),
                        width:
                        (MediaQuery.of(context).size.width - 150) * .75,
                      ),
                      SizedBox(
                        child: Icon(
                          Icons.chrome_reader_mode_outlined,
                          color: Color.fromRGBO(43, 59, 127, 1),
                        ),
                        width:
                        (MediaQuery.of(context).size.width - 200) * .25,
                      )
                    ],
                  )),
            ),

            SizedBox(height: 15),

            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(226, 226, 255, 50),
                  borderRadius: BorderRadius.circular(35)),
              margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: InkWell(
                  onTap: () {
                    navigateTo(32.164356, 35.852261);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: Text(
                          AppLocalizations.of(context)!.university_identity_renewal,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(43, 59, 127, 1),
                          ),
                        ),
                        width:
                        (MediaQuery.of(context).size.width - 150) * .75,
                      ),
                      SizedBox(
                        child: Icon(
                          Icons.picture_in_picture_sharp,
                          color: Color.fromRGBO(43, 59, 127, 1),
                        ),
                        width:
                        (MediaQuery.of(context).size.width - 200) * .25,
                      )
                    ],
                  )),
            ),
          ],
        ),
        ],
      ),

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
