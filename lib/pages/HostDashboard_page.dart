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
    //OpenSettings.openMainSetting()
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

  setUpHotspotConfig(BuildContext context) async {
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
            await usersRef.doc(userId).update({
              "ssid": ssIDController.text.trim(),
              "hotspot_password":
                  encrypter.encrypt(hostPassword.text.trim(), iv: iv).base64,
            }).then((_) async => {
                  await prefs
                      .setString("ssid", ssIDController.text.trim())
                      .then((_) => {
                            Navigator.pop(context),
                            setState(() {
                              isLoading = false;
                            })
                          })
                });
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
                    onPressed: () => setUpHotspotConfig(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PymantPage()),
              ),
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.settings),
                Text("hotsport settings")
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
                          notConnected: 'not Connected',
                          unavailable: 'unavailable',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "5")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '10MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "10")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '15MB',
                          subTitle: 'LKR 7',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "15")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '20MB',
                          subTitle: 'LKR 10',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "20")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '25MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "25")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '30MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "30")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '35MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "35")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '40MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "40")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '45MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "45")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '50MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "50")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '55MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "55")
                              : null,
                          btnClick: () {},
                        ),
                        CardWidget(
                          title: '60MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] != null &&
                                  snapshot.data["merchantSecret"] != null
                              ? () => modalWidget(context, "60")
                              : null,
                          btnClick: () {},
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
  final onClick;
  final btnClick;

  CardWidget(
      {this.subTitle,
      this.onClick,
      this.btnClick,
      this.title,
      this.notConnected,
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
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton.icon(
                        label: Text('Submit'),
                        icon: Icon(Icons.web),
                        onPressed: btnClick,
                        style: ElevatedButton.styleFrom(
                          primary: modalColor,
                          onPrimary: cardBtnTextColor,
                          // onSurface: Colors.red,
                        ),
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
