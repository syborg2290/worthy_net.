import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_settings/open_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worthy_net/config/collections.dart';
import 'package:worthy_net/pages/Paymant_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as KeyGet;

class HostDashboardPage extends StatefulWidget {
  @override
  _HostDashboardPageState createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage> {
  final TextEditingController hostPassword = new TextEditingController();
  final TextEditingController ssIDController = new TextEditingController();
  final TextEditingController priceChangeController =
      new TextEditingController();
  final TextEditingController timeController = new TextEditingController();
  bool isLoading = false;
  String userEmail = null;
  String userId = null;
  bool isInternetAvailabel = false;

  @override
  void initState() {
    super.initState();
    getUserEmailAndId();
  }

  getUserEmailAndId() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result = await usersRef
          .where("email", isEqualTo: prefs.getString("email"))
          .get();
      setState(() {
        userId = result.docs[0].id;
        userEmail = prefs.getString("email");
        isInternetAvailabel = true;
      });
    } else {
      setState(() {
        isInternetAvailabel = false;
      });
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

  setUpHotspotConfig(BuildContext context, String package) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      if (ssIDController.text != "") {
        if (hostPassword.text != "") {
          setState(() {
            isLoading = true;
          });

          final key = KeyGet.Key.fromUtf8('ghjklsgdferty27364uyrhjskytrghso');
          final iv = IV.fromLength(16);

          final encrypter = Encrypter(AES(key));
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var result =
                await usersRef.where("email", isEqualTo: userEmail).get();
            if (result.docs.length > 0) {
              if (!result.docs[0].data()["user"]) {
                await usersRef.doc(userId).update({
                  "ssid": ssIDController.text.trim(),
                  "host": true,
                  "hotspot_password": encrypter
                      .encrypt(hostPassword.text.trim(), iv: iv)
                      .base64,
                  "packages": {
                    "5": package == "5" ? true : false,
                    "10": package == "10" ? true : false,
                    "15": package == "15" ? true : false,
                    "20": package == "20" ? true : false,
                    "25": package == "25" ? true : false,
                    "30": package == "30" ? true : false,
                    "35": package == "35" ? true : false,
                    "40": package == "40" ? true : false,
                    "45": package == "45" ? true : false,
                    "50": package == "50" ? true : false,
                    "55": package == "55" ? true : false,
                    "60": package == "60" ? true : false,
                  }
                }).then((_) async => {
                      await prefs
                          .setString(
                              "ssid", ssIDController.text.trim().toLowerCase())
                          .then((_) => {
                                Navigator.pop(context),
                                setState(() {
                                  isLoading = false;
                                })
                              })
                    });
              } else {
                setState(() {
                  isLoading = false;
                });
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Info',
                  desc:
                      "You can't continue without disconnect currently using package as a user",
                  btnCancel: Text(""),
                  btnOk: Text(""),
                )..show();
              }
            }
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Info',
              desc: e.toString(),
              btnCancel: Text(""),
              btnOk: Text(""),
            )..show();
          }
        } else {
          setState(() {
            isLoading = false;
          });
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Info',
            desc: "All fields are required!",
            btnCancel: Text(""),
            btnOk: Text(""),
          )..show();
        }
      } else {
        setState(() {
          isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Info',
          desc: "All fields are required!",
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
        desc: "Please check your internet connection!",
        btnCancel: Text(""),
        btnOk: Text(""),
      )..show();
    }
  }

// ssid and hotspot password popup widget
  modalWidget(BuildContext context, String package) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          color: modalColor,
          child: Center(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: ssIDController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "SSID",
                        prefixIcon: Icon(Icons.important_devices_outlined)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: hostPassword,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Hotspot Password",
                        prefixIcon: Icon(Icons.wifi_lock_rounded)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 65),
                  child: Text('Enter your hotspot password and SSID',
                      style: TextStyle(fontSize: 20)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () => setUpHotspotConfig(context, package),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  updatePackagePrice(
      String package, double currentPrice, int currentTime) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      if (priceChangeController.text != "") {
        if (timeController.text != "") {
          if (int.parse(priceChangeController.text) >= 50) {
            usersRef.doc(userId).update({
              "packages_times": {
                "5": package == "5"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "10": package == "10"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "15": package == "15"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "20": package == "20"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "25": package == "25"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "30": package == "30"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "35": package == "35"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "40": package == "40"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "45": package == "45"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "50": package == "50"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "55": package == "55"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
                "60": package == "60"
                    ? int.parse(timeController.text.trim())
                    : currentTime,
              },
              "packages_prices": {
                "5": package == "5"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "10": package == "10"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "15": package == "15"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "20": package == "20"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "25": package == "25"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "30": package == "30"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "35": package == "35"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "40": package == "40"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "45": package == "45"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "50": package == "50"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "55": package == "55"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
                "60": package == "60"
                    ? double.parse(priceChangeController.text.trim())
                    : currentPrice,
              }
            }).then((value) => {Navigator.pop(context)});
          }
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Info',
            desc: "Price must be 50LKR or higher",
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

  // Price and time  change popup widget
  modalPriceChengeWidget(BuildContext context, String package,
      double currentPrice, int currentTime) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2.5,
          color: modalColor,
          child: Center(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: priceChangeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter package price",
                        prefixIcon: Icon(Icons.monetization_on_outlined)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter package Time(min)",
                        prefixIcon: Icon(Icons.timer)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 120),
                  child: Text(package + "MB package",
                      style: TextStyle(fontSize: 20)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () =>
                        updatePackagePrice(package, currentPrice, currentTime),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  disablePackage(String package, dynamic currentStatus) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      await usersRef.doc(userId).update({
        "packages": {
          "5": package == "5" ? false : currentStatus["5"],
          "10": package == "10" ? false : currentStatus["10"],
          "15": package == "15" ? false : currentStatus["15"],
          "20": package == "20" ? false : currentStatus["20"],
          "25": package == "25" ? false : currentStatus["25"],
          "30": package == "30" ? false : currentStatus["30"],
          "35": package == "35" ? false : currentStatus["35"],
          "40": package == "40" ? false : currentStatus["40"],
          "45": package == "45" ? false : currentStatus["45"],
          "50": package == "50" ? false : currentStatus["50"],
          "55": package == "55" ? false : currentStatus["55"],
          "60": package == "60" ? false : currentStatus["60"],
        }
      }).then((_) => {
            setState(() {
              isLoading = false;
            })
          });
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

  @override
  Widget build(BuildContext context) {
    // data package card media query
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: <Widget>[
          FlatButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PymantPage()),
              ),
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.monetization_on),
                Text("Setup the payment")
              ],
            ),
          ),
          FlatButton(
            onPressed: () => {OpenSettings.openMainSetting()},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.wifi_protected_setup),
                Text("Turn on hotspot"),
              ],
            ),
          ),
        ],
      ),
      body: userEmail == null && userId == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => getUserEmailAndId(),
              strokeWidth: 4.0,
              child: StreamBuilder(
                  stream: usersRef.doc(userId).snapshots(),
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
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["5"]
                                  .toString(),
                              title: '5MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["5"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["5"],
                              notConnected: snapshot.data["packages"]["5"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["5"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["5"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "5")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "5", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["5"] == true &&
                                      snapshot.data["connectedCount"]["5"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "5",
                                        snapshot.data["packages_prices"]["5"],
                                        snapshot.data["packages_times"]["5"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["10"]
                                  .toString(),
                              title: '10MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["10"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["10"],
                              notConnected: snapshot.data["packages"]["10"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["10"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["10"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "10")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "10", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["10"] == true &&
                                      snapshot.data["connectedCount"]["10"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "10",
                                        snapshot.data["packages_prices"]["10"],
                                        snapshot.data["packages_times"]["10"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["15"]
                                  .toString(),
                              title: '15MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["15"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["15"],
                              notConnected: snapshot.data["packages"]["15"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["15"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["15"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "15")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "15", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["15"] == true &&
                                      snapshot.data["connectedCount"]["15"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "15",
                                        snapshot.data["packages_prices"]["15"],
                                        snapshot.data["packages_times"]["15"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["20"]
                                  .toString(),
                              title: '20MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["20"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["20"],
                              notConnected: snapshot.data["packages"]["20"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["20"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["20"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "20")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "20", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["20"] == true &&
                                      snapshot.data["connectedCount"]["20"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "20",
                                        snapshot.data["packages_prices"]["20"],
                                        snapshot.data["packages_times"]["20"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["25"]
                                  .toString(),
                              title: '25MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["25"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["25"],
                              notConnected: snapshot.data["packages"]["25"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["25"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["25"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "25")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "25", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["25"] == true &&
                                      snapshot.data["connectedCount"]["25"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "25",
                                        snapshot.data["packages_prices"]["25"],
                                        snapshot.data["packages_times"]["25"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["30"]
                                  .toString(),
                              title: '30MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["30"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["30"],
                              notConnected: snapshot.data["packages"]["30"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["30"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["30"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "30")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "30", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["30"] == true &&
                                      snapshot.data["connectedCount"]["30"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "30",
                                        snapshot.data["packages_prices"]["30"],
                                        snapshot.data["packages_times"]["30"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["35"]
                                  .toString(),
                              title: '35MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["35"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["35"],
                              notConnected: snapshot.data["packages"]["35"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["35"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["35"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "35")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "35", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["35"] == true &&
                                      snapshot.data["connectedCount"]["35"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "35",
                                        snapshot.data["packages_prices"]["35"],
                                        snapshot.data["packages_times"]["35"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["40"]
                                  .toString(),
                              title: '40MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["40"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["40"],
                              notConnected: snapshot.data["packages"]["40"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["40"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["40"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "40")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "40", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["40"] == true &&
                                      snapshot.data["connectedCount"]["40"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "40",
                                        snapshot.data["packages_prices"]["40"],
                                        snapshot.data["packages_times"]["40"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["45"]
                                  .toString(),
                              title: '45MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["45"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["45"],
                              notConnected: snapshot.data["packages"]["45"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["45"] > 0
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["45"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "45")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "45", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["45"] == true &&
                                      snapshot.data["connectedCount"]["45"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "45",
                                        snapshot.data["packages_prices"]["45"],
                                        snapshot.data["packages_times"]["45"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["50"]
                                  .toString(),
                              title: '50MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["50"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["50"],
                              notConnected: snapshot.data["packages"]["50"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["50"] > 50
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["50"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "50")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "50", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["isConnected"] ==
                                          true &&
                                      snapshot.data["packages"]["50"] == true &&
                                      snapshot.data["connectedCount"]["50"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "50",
                                        snapshot.data["packages_prices"]["50"],
                                        snapshot.data["packages_times"]["50"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["55"]
                                  .toString(),
                              title: '55MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["55"]
                                      .toString(),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["55"],
                              notConnected: snapshot.data["packages"]["55"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["55"] > 55
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["55"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "55")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnClick: () => disablePackage(
                                  "55", snapshot.data["packages"]),
                              btnPriceChange: snapshot.data["packages"]["55"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["55"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "55",
                                        snapshot.data["packages_prices"]["55"],
                                        snapshot.data["packages_times"]["55"],
                                      ),
                            ),
                            CardWidget(
                              isConnected: snapshot.data["isConnected"],
                              packagetime: snapshot.data["packages_times"]["60"]
                                  .toString(),
                              title: '60MB',
                              subTitle: 'LKR ' +
                                  snapshot.data["packages_prices"]["60"]
                                      .toString(),
                              btnClick: () => disablePackage(
                                  "60", snapshot.data["packages"]),
                              connectedCount: snapshot.data["connectedCount"]
                                  ["60"],
                              notConnected: snapshot.data["packages"]["60"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["60"] > 60
                                  ? "Connected"
                                  : "Not connected",
                              unavailable:
                                  snapshot.data["packages"]["60"] == true
                                      ? "Available"
                                      : "Unavailable",
                              onClick: snapshot.data["merchantId"] != null &&
                                      snapshot.data["merchantSecret"] != null
                                  ? () => modalWidget(context, "60")
                                  : () => {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Info',
                                          desc: "Payment details required!",
                                          btnCancel: Text(""),
                                          btnOk: Text(""),
                                        )..show()
                                      },
                              btnPriceChange: snapshot.data["packages"]["60"] ==
                                          true &&
                                      snapshot.data["connectedCount"]["60"] > 0
                                  ? null
                                  : () => modalPriceChengeWidget(
                                        context,
                                        "60",
                                        snapshot.data["packages_prices"]["60"],
                                        snapshot.data["packages_times"]["60"],
                                      ),
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
  final String packagetime;
  final String title;
  final String unavailable;
  final String notConnected;
  final int connectedCount;
  final bool isConnected;
  final onClick;
  final btnClick;
  final btnPriceChange;

  CardWidget(
      {this.subTitle,
      this.packagetime,
      this.onClick,
      this.btnClick,
      this.btnPriceChange,
      this.isConnected,
      this.title,
      this.notConnected,
      this.connectedCount,
      this.unavailable});

//host page card
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: blueLightColors,
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
                      double.parse(packagetime).toString() + " Min",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: textColors,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton.icon(
                      label: Text('Price and time'),
                      icon: Icon(Icons.credit_card_outlined),
                      onPressed: btnPriceChange,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        onPrimary: Colors.black,
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
                              label: Text('Disable'),
                              icon: Icon(Icons.web),
                              onPressed: btnClick,
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
                      child: Text(
                        notConnected,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: notConnectedColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    notConnected == "Connected"
                        ? Container(
                            child: Text(
                              "Connected count :" + connectedCount.toString(),
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.black12,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : Text(""),
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
