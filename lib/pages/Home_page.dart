import 'dart:io';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worthy_net/pages/Login_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/widgets/GridDashbord.dart';
import 'package:worthy_net/widgets/Header_container.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int down = 0;
  int up = 0;
  int packageTime = 0;
  String ssid = "Not connected";

  @override
  void initState() {
    super.initState();
    getBackgroundTask();
  }

  getBackgroundTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("connected_ssid") != null) {
      final cron = Cron()
        ..schedule(Schedule.parse('*/1 * * * * *'), () async {
          int packageTimel = prefs.getInt("package_time");
          int upl = prefs.getInt("random_up");
          int downl = prefs.getInt("random_down");
          setState(() {
            ssid = prefs.getString("connected_ssid");
            up = upl;
            down = downl;
            packageTime = packageTimel;
          });
        });
    }

    // await Future.delayed(Duration(seconds: 2));
    // await cron.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashbordColor,
      body: WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: Column(
          children: <Widget>[
            HeaderContainer("Dashbord"),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: Text(
                          "Connected SSID :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: Text(
                          "⏳ Duration :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: Text(
                          "⬆ Upload Speed :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        child: Text(
                          "⬇ Download speed :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: Text(
                          ssid,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textGreenColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: Text(
                          double.parse(packageTime.toString()).toString() +
                              " Min",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textGreenColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: Text(
                          double.parse(up.toString()).toString() + " KPS",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textGreenColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        child: Text(
                          double.parse(down.toString()).toString() + " KPS",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textGreenColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: TextButton(
                      child: Text('Logout'),
                      style: TextButton.styleFrom(
                        primary: textColors,
                        backgroundColor: blueLightColors,
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove("email").then((con) => {
                              if (con)
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()))
                                }
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GridDashbor(),
          ],
        ),
      ),
    );
  }
}
