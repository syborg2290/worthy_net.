import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payhere/payhere.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_wifi/simply_wifi.dart';
import 'package:worthy_net/config/collections.dart';
import 'package:worthy_net/pages/Home_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:encrypt/encrypt.dart' as KeyGet;
import 'package:encrypt/encrypt.dart';

class UserDetailsPage extends StatefulWidget {
  final int index;
  final String email;
  final String userId;
  final String ssid;
  final String hotspassword;
  final String merchantId;
  final String merchantSec;
  UserDetailsPage(this.index, this.email, this.userId, this.ssid,
      this.hotspassword, this.merchantId, this.merchantSec);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  bool isLoading = false;

  makePayment(
      String package, int connectedCount, double price, int packageTime) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result = await usersRef
          .where("email", isEqualTo: prefs.getString("email"))
          .get();
      if (result.docs.length > 0) {
        if (result.docs[0].data()["host"] != true) {
          if (result.docs[0].data()["user"] != true) {
            final key = KeyGet.Key.fromUtf8('ghjklsgdferty27364uyrhjskytrghso');
            final iv = IV.fromLength(16);
            final encrypter = Encrypter(AES(key));
            var random = new Random();

            // Payhere payhere = new Payhere();
            // OneTimePayment otp = new OneTimePayment(
            //     merchantID: encrypter.decrypt64(widget.merchantId, iv: iv),
            //     merchantSecret: encrypter.decrypt64(widget.merchantSec, iv: iv),
            //     notifyUrl: "",
            //     currency: "LKR", //Currency code LKR/USD/GBP/EUR/AUD
            //     totalamount: price, // Final Amount to be charged.
            //     orderID:
            //         random.nextInt(100000).toString(), // Unique Reference ID
            //     itemDesc: package, // Item description title
            //     cM1: "CM1",
            //     cM2: "CM2",
            //     fName: result.docs[0].data()["fname"],
            //     lName: result.docs[0].data()["lname"],
            //     email: result.docs[0].data()["email"],
            //     phone: result.docs[0].data()["phonenumber"],
            //     address: "Address",
            //     city: "Colombo",
            //     country: "Sri Lanka",
            //     //following are optional values as stated in the Payhere android SDK.
            //     //you can avoid setting them if you wanted to.
            //     deliveryAddress: "deliveryAddress",
            //     deliveryCity: "deliveryAddress",
            //     deliveryCountry: "deliveryAddress");

            // String resPayhere = await payhere.makeOneTimePayment(otp);

            // if (json.decode(resPayhere)["STATUS"] == "SUCCESS") {
            //   connectToHotspot(package, connectedCount, packageTime);
            // } else if (json.decode(resPayhere)["STATUS"] == "ERROR") {
            //   AwesomeDialog(
            //     context: context,
            //     dialogType: DialogType.WARNING,
            //     animType: AnimType.BOTTOMSLIDE,
            //     title: 'Info',
            //     desc: "Payment encountered an Error",
            //     btnCancel: Text(""),
            //     btnOk: Text(""),
            //   )..show();

            // } else if (json.decode(resPayhere)["STATUS"] == "CANCELED") {
            //   AwesomeDialog(
            //     context: context,
            //     dialogType: DialogType.WARNING,
            //     animType: AnimType.BOTTOMSLIDE,
            //     title: 'Info',
            //     desc: "Payment is Canceled",
            //     btnCancel: Text(""),
            //     btnOk: Text(""),
            //   )..show();
            // }
            connectToHotspot(package, connectedCount, packageTime);
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Info',
              desc:
                  "You can't continue without diconnect currently using package as a user",
              btnCancel: Text(""),
              btnOk: Text(""),
            )..show();
          }
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Info',
            desc:
                "You can't continue without disable currently using package as a host",
            btnCancel: Text(""),
            btnOk: Text(""),
          )..show();
        }
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Info',
        desc: "Please check your internet connection!",
        btnCancel: Text(""),
        btnOk: Text(""),
      )..show();
    }
  }

  connectToHotspot(String package, int connectedCount, int packageTime) async {
    final key = KeyGet.Key.fromUtf8('ghjklsgdferty27364uyrhjskytrghso');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    try {
      SimplyWifi.connectWifiByName(widget.ssid,
              password: encrypter.decrypt64(widget.hotspassword, iv: iv))
          .then((value) async => {
                if (value)
                  {
                    await usersRef.doc(widget.userId).update({
                      "isConnected": true,
                      "host": true,
                      "connectedCount": {
                        "5": package == "5"
                            ? connectedCount + 1
                            : connectedCount,
                        "10": package == "10"
                            ? connectedCount + 1
                            : connectedCount,
                        "15": package == "15"
                            ? connectedCount + 1
                            : connectedCount,
                        "20": package == "20"
                            ? connectedCount + 1
                            : connectedCount,
                        "25": package == "25"
                            ? connectedCount + 1
                            : connectedCount,
                        "30": package == "30"
                            ? connectedCount + 1
                            : connectedCount,
                        "35": package == "35"
                            ? connectedCount + 1
                            : connectedCount,
                        "40": package == "40"
                            ? connectedCount + 1
                            : connectedCount,
                        "45": package == "45"
                            ? connectedCount + 1
                            : connectedCount,
                        "50": package == "50"
                            ? connectedCount + 1
                            : connectedCount,
                        "55": package == "55"
                            ? connectedCount + 1
                            : connectedCount,
                        "60": package == "60"
                            ? connectedCount + 1
                            : connectedCount,
                      }
                    }).then((_) async => {
                          await currentUserIsConnected(
                              widget.userId, package, packageTime)
                        }),
                  }
                else
                  {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Info',
                      desc: "Wrong SSID, Please try agaian to connect",
                      btnCancel: Text(""),
                      btnOk: Text(""),
                    )..show()
                  }
              });
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Info',
        desc: e,
        btnCancel: Text(""),
        btnOk: Text(""),
      )..show();
    }
  }

  currentUserIsConnected(
      String hostuserIdF, String package, int packageTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("host_userId", hostuserIdF);
    await prefs.setString("package", package);
    var result = await usersRef
        .where("email", isEqualTo: prefs.getString("email"))
        .get();
    if (result.docs.length > 0) {
      await prefs.setInt("initial_packageTime", packageTime);
      await prefs.setInt("package_time", 0);
      await prefs.setInt("random_up", 0);
      await prefs.setInt("random_down", 0);
      usersRef.doc(result.docs[0].id).update({
        "isConnected": true,
        "user": true,
        "host_ssid": widget.ssid,
        "host_id": widget.userId,
      }).then((_) => {
            prefs.setString("connected_ssid", widget.ssid).then((_) => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()))
                }),
          });
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
                                  setState(() {
                                    isLoading = false;
                                  })
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
    //mediaquery
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages details'),
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          return false;
        },
        child: StreamBuilder(
            stream: usersRef.doc(widget.userId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  color: packageCardColor,
                  child: GridView.count(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 1,
                    childAspectRatio: (itemWidth / itemHeight),
                    children: <Widget>[
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["5"].toString(),
                        title: '5MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["5"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["5"],
                        notConnected: snapshot.data["packages"]["5"] == true &&
                                snapshot.data["connectedCount"]["5"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["5"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["5"] == true
                            ? makePayment(
                                "5",
                                snapshot.data["connectedCount"]["5"],
                                snapshot.data["packages_prices"]["5"],
                                int.parse(snapshot.data["packages_times"]["5"]
                                    .toString()),
                              )
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["10"].toString(),
                        title: '10MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["10"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["10"],
                        notConnected: snapshot.data["packages"]["10"] == true &&
                                snapshot.data["connectedCount"]["10"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["10"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["10"] == true
                            ? makePayment(
                                "10",
                                snapshot.data["connectedCount"]["10"],
                                snapshot.data["packages_prices"]["10"],
                                int.parse(snapshot.data["packages_times"]["10"]
                                    .toString()),
                              )
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["15"].toString(),
                        title: '15MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["15"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["15"],
                        notConnected: snapshot.data["packages"]["15"] == true &&
                                snapshot.data["connectedCount"]["15"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["15"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["15"] == true
                            ? makePayment(
                                "15",
                                snapshot.data["connectedCount"]["15"],
                                snapshot.data["packages_prices"]["15"],
                                int.parse(snapshot.data["packages_times"]["15"]
                                    .toString()),
                              )
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["20"].toString(),
                        title: '20MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["20"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["20"],
                        notConnected: snapshot.data["packages"]["20"] == true &&
                                snapshot.data["connectedCount"]["20"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["20"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["20"] == true
                            ? makePayment(
                                "20",
                                snapshot.data["connectedCount"]["20"],
                                snapshot.data["packages_prices"]["20"],
                                int.parse(snapshot.data["packages_times"]["20"]
                                    .toString()),
                              )
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["25"].toString(),
                        title: '25MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["25"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["25"],
                        notConnected: snapshot.data["packages"]["25"] == true &&
                                snapshot.data["connectedCount"]["25"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["25"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["25"] == true
                            ? makePayment(
                                "25",
                                snapshot.data["connectedCount"]["25"],
                                snapshot.data["packages_prices"]["25"],
                                int.parse(snapshot.data["packages_times"]["25"]
                                    .toString()))
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["30"].toString(),
                        title: '30MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["30"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["30"],
                        notConnected: snapshot.data["packages"]["30"] == true &&
                                snapshot.data["connectedCount"]["30"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["30"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["30"] == true
                            ? makePayment(
                                "30",
                                snapshot.data["connectedCount"]["30"],
                                snapshot.data["packages_prices"]["30"],
                                int.parse(snapshot.data["packages_times"]["30"]
                                    .toString()),
                              )
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["35"].toString(),
                        title: '35MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["35"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["35"],
                        notConnected: snapshot.data["packages"]["35"] == true &&
                                snapshot.data["connectedCount"]["35"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["35"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["35"] == true
                            ? makePayment(
                                "35",
                                snapshot.data["connectedCount"]["35"],
                                snapshot.data["packages_prices"]["35"],
                                int.parse(snapshot.data["packages_times"]["35"]
                                    .toString()))
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["40"].toString(),
                        title: '40MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["40"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["40"],
                        notConnected: snapshot.data["packages"]["40"] == true &&
                                snapshot.data["connectedCount"]["40"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["40"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["40"] == true
                            ? makePayment(
                                "40",
                                snapshot.data["connectedCount"]["40"],
                                snapshot.data["packages_prices"]["40"],
                                int.parse(snapshot.data["packages_times"]["40"]
                                    .toString()),
                              )
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["45"].toString(),
                        title: '45MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["45"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["45"],
                        notConnected: snapshot.data["packages"]["45"] == true &&
                                snapshot.data["connectedCount"]["45"] > 0
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["45"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["45"] == true
                            ? makePayment(
                                "45",
                                snapshot.data["connectedCount"]["45"],
                                snapshot.data["packages_prices"]["45"],
                                int.parse(snapshot.data["packages_times"]["45"]
                                    .toString()))
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["50"].toString(),
                        title: '50MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["50"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["50"],
                        notConnected: snapshot.data["packages"]["50"] == true &&
                                snapshot.data["connectedCount"]["50"] > 50
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["50"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["50"] == true
                            ? makePayment(
                                "50",
                                snapshot.data["connectedCount"]["50"],
                                snapshot.data["packages_prices"]["50"],
                                int.parse(snapshot.data["packages_times"]["50"]
                                    .toString()))
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["55"].toString(),
                        title: '55MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["55"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["55"],
                        notConnected: snapshot.data["packages"]["55"] == true &&
                                snapshot.data["connectedCount"]["55"] > 55
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["55"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["55"] == true
                            ? makePayment(
                                "55",
                                snapshot.data["connectedCount"]["55"],
                                snapshot.data["packages_prices"]["55"],
                                int.parse(snapshot.data["packages_times"]["55"]
                                    .toString()))
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                      CardWidget(
                        packageTime:
                            snapshot.data["packages_times"]["60"].toString(),
                        title: '60MB',
                        subTitle: 'LKR ' +
                            snapshot.data["packages_prices"]["60"].toString(),
                        connectedCount: snapshot.data["connectedCount"]["60"],
                        notConnected: snapshot.data["packages"]["60"] == true &&
                                snapshot.data["connectedCount"]["60"] > 60
                            ? "Connected"
                            : "Not connected",
                        unavailable: snapshot.data["packages"]["60"] == true
                            ? "Available"
                            : "Unavailable",
                        onClick: () => snapshot.data["packages"]["60"] == true
                            ? makePayment(
                                "60",
                                snapshot.data["connectedCount"]["60"],
                                snapshot.data["packages_prices"]["60"],
                                int.parse(snapshot.data["packages_times"]["60"]
                                    .toString()))
                            : null,
                        btnClick: () async => await disconnectPackage(),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String subTitle;
  final String title;
  final String unavailable;
  final String notConnected;
  final int connectedCount;
  final String packageTime;
  final onClick;
  final btnClick;

  CardWidget(
      {this.subTitle,
      this.packageTime,
      this.onClick,
      this.btnClick,
      this.title,
      this.notConnected,
      this.connectedCount,
      this.unavailable});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: unavailable == "Available" ? dashbordColor : blueLightColors,
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 25),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      title,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: textColors,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      subTitle,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: textColors,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      double.parse(packageTime).toString() + " Min",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: textColors,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    unavailable == "Available"
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton.icon(
                              label: Text('Disconnect'),
                              icon: Icon(Icons.web),
                              onPressed:
                                  notConnected == "Connected" ? btnClick : null,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                onPrimary: cardBtnTextColor,
                              ),
                            ),
                          )
                        : Text(""),
                    Container(
                      child: Text(
                        unavailable,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: unavailableColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 70),
                      child: Text(
                        notConnected,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
