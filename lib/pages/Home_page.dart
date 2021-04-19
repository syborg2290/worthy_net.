// import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/widgets/GridDashbord.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worthy_net/pages/Login_page.dart';
import 'package:worthy_net/widgets/Header_container.dart';

class HomePage extends StatelessWidget {
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
                    // alignment: Alignment.topCenter,
                    // icon: Image.asset("assets/logo.png", width: 24),
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
