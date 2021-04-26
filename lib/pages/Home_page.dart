import 'dart:io';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_wifi/simply_wifi.dart';
import 'package:worthy_net/config/collections.dart';
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
    if (prefs.getString("connected_ssid") != "") {
      if (prefs.getInt("package_time") != null) {
        if (prefs.getInt("random_up") != null) {
          if (prefs.getInt("random_down") != null) {
            final cron = Cron()
              ..schedule(Schedule.parse('*/1 * * * * *'), () async {
                var getTime = prefs.getInt("package_time");
                var getInitTime = prefs.getInt("initial_packageTime");

                if (getTime != null) {
                  if (getTime >= getInitTime * 60) {
                    // await prefs.setInt("package_time", null);
                    // await prefs.setInt("random_up", null);
                    // await prefs.setInt("random_down", null);
                    setState(() {
                      ssid = "Not connected";
                      up = 0;
                      down = 0;
                      packageTime = 0;
                    });
                    if (prefs.getString("connected_ssid") != "") {
                      await disconnectPackage();
                    }
                  } else {
                    Random random = new Random();
                    int rUp = 50 + random.nextInt(100 - 10);
                    int rDown = 40 + random.nextInt(200 - 10);
                    await prefs.setInt("package_time", getTime + 1);
                    await prefs.setInt("random_up", rUp);
                    await prefs.setInt("random_down", rDown);
                  }
                }

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
        }
      }
    }
  }

  disconnectPackage() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var connectedSsid = prefs.getString("connected_ssid");
      if (connectedSsid != "") {
        var connectedPackage = prefs.getString("package");
        var hostuserIdShared = prefs.getString("host_userId");
        int count = 0;
        var result = await usersRef
            .where("email", isEqualTo: prefs.getString("email"))
            .get();
        if (result.docs.length > 0) {
          usersRef.doc(result.docs[0].id).update({
            "isConnected": false,
            "user": false,
            "host_ssid": null,
            "host_id": null,
          }).then((_) async => {
                await usersRef.doc(hostuserIdShared).get().then((resultGet) => {
                      count = resultGet.data()["connectedCount"]["5"] +
                          resultGet.data()["connectedCount"]["10"] +
                          resultGet.data()["connectedCount"]["15"] +
                          resultGet.data()["connectedCount"]["20"] +
                          resultGet.data()["connectedCount"]["25"] +
                          resultGet.data()["connectedCount"]["30"] +
                          resultGet.data()["connectedCount"]["35"] +
                          resultGet.data()["connectedCount"]["40"] +
                          resultGet.data()["connectedCount"]["45"] +
                          resultGet.data()["connectedCount"]["50"] +
                          resultGet.data()["connectedCount"]["55"] +
                          resultGet.data()["connectedCount"]["60"],
                      prefs.setString("connected_ssid", "").then((_) async => {
                            await usersRef.doc(hostuserIdShared).update({
                              "isConnected": count > 1 ? true : false,
                              "host": count > 1 ? true : false,
                              "connectedCount": {
                                "5": connectedPackage == "5"
                                    ? resultGet.data()["connectedCount"]["5"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["5"] -
                                            1
                                    : resultGet.data()["connectedCount"]["5"],
                                "10": connectedPackage == "10"
                                    ? resultGet.data()["connectedCount"]["10"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["10"] -
                                            1
                                    : resultGet.data()["connectedCount"]["10"],
                                "15": connectedPackage == "15"
                                    ? resultGet.data()["connectedCount"]["15"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["15"] -
                                            1
                                    : resultGet.data()["connectedCount"]["15"],
                                "20": connectedPackage == "20"
                                    ? resultGet.data()["connectedCount"]["20"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["20"] -
                                            1
                                    : resultGet.data()["connectedCount"]["20"],
                                "25": connectedPackage == "25"
                                    ? resultGet.data()["connectedCount"]["25"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["25"] -
                                            1
                                    : resultGet.data()["connectedCount"]["25"],
                                "30": connectedPackage == "30"
                                    ? resultGet.data()["connectedCount"]["30"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["30"] -
                                            1
                                    : resultGet.data()["connectedCount"]["30"],
                                "35": connectedPackage == "35"
                                    ? resultGet.data()["connectedCount"]["35"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["35"] -
                                            1
                                    : resultGet.data()["connectedCount"]["35"],
                                "40": connectedPackage == "40"
                                    ? resultGet.data()["connectedCount"]["40"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["40"] -
                                            1
                                    : resultGet.data()["connectedCount"]["40"],
                                "45": connectedPackage == "45"
                                    ? resultGet.data()["connectedCount"]["45"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["45"] -
                                            1
                                    : resultGet.data()["connectedCount"]["45"],
                                "50": connectedPackage == "50"
                                    ? resultGet.data()["connectedCount"]["50"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["50"] -
                                            1
                                    : resultGet.data()["connectedCount"]["50"],
                                "55": connectedPackage == "55"
                                    ? resultGet.data()["connectedCount"]["55"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["55"] -
                                            1
                                    : resultGet.data()["connectedCount"]["55"],
                                "60": connectedPackage == "60"
                                    ? resultGet.data()["connectedCount"]["60"] -
                                                1 <
                                            0
                                        ? 0
                                        : resultGet.data()["connectedCount"]
                                                ["60"] -
                                            1
                                    : resultGet.data()["connectedCount"]["60"],
                              }
                            }).then((_) async => {
                                  SimplyWifi.disconnectWifi(),
                                  SimplyWifi.forgetWifiByWifiName(
                                      connectedSsid),
                                  // await SimplyWifi.turnOffWifi(),
                                  await prefs.setString("package", ""),
                                  await prefs.setString("host_userId", ""),
                                  await Cron().close(),
                                }),
                          }),
                    }),
              });
        }
      }
    } else {
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.INFO,
      //   animType: AnimType.BOTTOMSLIDE,
      //   title: 'Info',
      //   desc: "Please check your internet connection!",
      //   btnCancel: Text(""),
      //   btnOk: Text(""),
      // )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(3.0), // here the desired height
          child: AppBar(
            automaticallyImplyLeading: false,
          )),
      backgroundColor: dashbordColor,
      body: WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: ListView(
          children: <Widget>[
            HeaderContainer("Dashbord"),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 70),
                        child: Text(
                          "Connected SSID : ",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 70),
                        child: Text(
                          "Duration :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 70),
                        child: Text(
                          "Upload Speed :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 70),
                        child: Text(
                          "Download speed :",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textSilverColor,
                                  fontSize: 18,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 60),
                        child: Text(
                          double.parse(((packageTime / 60).toStringAsFixed(1))
                                      .toString())
                                  .toString() +
                              " Min",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textGreenColor,
                                  fontSize: 18,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Container(
                        child: Text(
                          double.parse(down.toString()).toString() + " KPS",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: textGreenColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                  child: Column(
                    children: <Widget>[
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
                                              builder: (context) =>
                                                  LoginPage()))
                                    }
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GridDashbor(),
            // Home page card load
          ],
        ),
      ),
    );
  }
}
