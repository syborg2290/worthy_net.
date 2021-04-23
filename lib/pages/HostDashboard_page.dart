import 'package:awesome_dialog/awesome_dialog.dart';
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
  bool isLoading = false;
  String userEmail = null;
  String userId = null;

  @override
  void initState() {
    super.initState();
    getUserEmailAndId();
  }

  getUserEmailAndId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await usersRef
        .where("email", isEqualTo: prefs.getString("email"))
        .get();
    setState(() {
      userId = result.docs[0].id;
      userEmail = prefs.getString("email");
    });
  }

  setUpHotspotConfig(BuildContext context, String package) async {
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
                "hotspot_password":
                    encrypter.encrypt(hostPassword.text.trim(), iv: iv).base64,
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
  }

  modalWidget(BuildContext context, String package) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          // width: double.infinity,
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
                  // width: MediaQuery.of(context).size.width,
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

  disablePackage(String package, dynamic currentStatus) async {
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
  }

  @override
  Widget build(BuildContext context) {
    // data package card media query
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
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
          : StreamBuilder(
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
                          title: '5MB',
                          subTitle: 'LKR 2',
                          connectedCount: snapshot.data["connectedCount"]["5"],
                          notConnected:
                              snapshot.data["packages"]["5"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["5"] == true
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
                          btnClick: () =>
                              disablePackage("5", snapshot.data["packages"]),
                        ),
                        //////////////////////////////////////////////////////////////
                        CardWidget(
                          title: '10MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["10"],
                          notConnected:
                              snapshot.data["packages"]["10"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["10"] == true
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
                          btnClick: () =>
                              disablePackage("10", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '15MB',
                          subTitle: 'LKR 7',
                          connectedCount: snapshot.data["connectedCount"]["15"],
                          notConnected:
                              snapshot.data["packages"]["15"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["15"] == true
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
                          btnClick: () =>
                              disablePackage("15", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '20MB',
                          subTitle: 'LKR 10',
                          connectedCount: snapshot.data["connectedCount"]["20"],
                          notConnected:
                              snapshot.data["packages"]["20"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["20"] == true
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
                          btnClick: () =>
                              disablePackage("20", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '25MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["25"],
                          notConnected:
                              snapshot.data["packages"]["25"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["25"] == true
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
                          btnClick: () =>
                              disablePackage("25", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '30MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["30"],
                          notConnected:
                              snapshot.data["packages"]["30"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["30"] == true
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
                          btnClick: () =>
                              disablePackage("30", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '35MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["35"],
                          notConnected:
                              snapshot.data["packages"]["35"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["35"] == true
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
                          btnClick: () =>
                              disablePackage("35", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '40MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["40"],
                          notConnected:
                              snapshot.data["packages"]["40"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["40"] == true
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
                          btnClick: () =>
                              disablePackage("40", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '45MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["45"],
                          notConnected:
                              snapshot.data["packages"]["45"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["45"] == true
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
                          btnClick: () =>
                              disablePackage("45", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '50MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["50"],
                          notConnected:
                              snapshot.data["packages"]["50"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["50"] == true
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
                          btnClick: () =>
                              disablePackage("50", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '55MB',
                          subTitle: 'LKR 5',
                          connectedCount: snapshot.data["connectedCount"]["55"],
                          notConnected:
                              snapshot.data["packages"]["55"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["55"] == true
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
                          btnClick: () =>
                              disablePackage("55", snapshot.data["packages"]),
                        ),
                        CardWidget(
                          title: '60MB',
                          subTitle: 'LKR 5',
                          btnClick: () =>
                              disablePackage("60", snapshot.data["packages"]),
                          connectedCount: snapshot.data["connectedCount"]["60"],
                          notConnected:
                              snapshot.data["packages"]["60"] == true &&
                                      snapshot.data["isConnected"] == true
                                  ? "Connected"
                                  : "Not connected",
                          unavailable: snapshot.data["packages"]["60"] == true
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
                        ),
                      ],
                    ),
                  );
                }
              }),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String subTitle;
  final String title;
  final String unavailable;
  final String notConnected;
  final int connectedCount;
  final onClick;
  final btnClick;

  CardWidget(
      {this.subTitle,
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
                            fontSize: 50,
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
                            fontSize: 25,
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
                    unavailable == "Available" && notConnected == "Connected"
                        ? Container(
                            // margin: EdgeInsets.only(top: 30),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton.icon(
                              label: Text('Disable'),
                              icon: Icon(Icons.web),
                              onPressed: btnClick,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                onPrimary: cardBtnTextColor,
                                // onSurface: Colors.red,
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
                      // padding: EdgeInsets.only(bottom: 4.0),
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
                            // padding: EdgeInsets.only(bottom: 4.0),
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
