import 'dart:io';
import 'package:flutter/material.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/widgets/GridDashbord.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worthy_net/pages/Login_page.dart';
import 'package:worthy_net/widgets/Header_container.dart';

class HomePage extends StatelessWidget {
  final String duration ="555221";
  final String receieved ="11445";

  // const HomePage({ this.duration,this.receieved});

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
                          "Duration :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Received :",
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
                          duration,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textGreenColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        child: Text(
                          receieved,
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
