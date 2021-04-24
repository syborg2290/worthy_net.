import 'dart:io';
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
  @override
  void initState() {
    super.initState();
  }

  getBackgroundTask() async {
    // final cron = Cron()
    //   ..schedule(Schedule.parse('*/1 * * * * *'), () async {
    //     int downF = await getDownSpeed();
    //     int uploadF = await getUploadSpeed();
    //     print("Download rate " + (downF / 1000).toString());
    //     print("Upload rate " + (uploadF / 1000).toString());
    //   });
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
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Worthy Net",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: textColors,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ),
                      // SizedBox(
                      //   height: 4,
                      // ),
                    ],
                  ),
                  TextButton(
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
