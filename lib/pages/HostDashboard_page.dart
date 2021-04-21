import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  setUpHotspotConfig(BuildContext context) async {
    if (ssIDController.text != "") {
      if (hostPassword.text != "") {
        setState(() {
          isLoading = true;
        });
        final key = KeyGet.Key.fromUtf8(
            'ufdsuyr8734rfhjsdfksklfdsigfysjdsfdsgsfhgh878');
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
                  encrypter.encrypt(hostPassword.text.trim(), iv: iv),
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
            desc: e,
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

  modalWidget(BuildContext context, String package) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: modalColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Enter your hotspot password SSID',
                    style: TextStyle(fontSize: 20)),
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
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () => setUpHotspotConfig(context),
                )
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
        title: Text('Packages'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PymantPage()),
              ),
            },
            // padding: EdgeInsets.all(0.5),
            child: Column(
              // Replace with a Row for horizontal icon + text
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.monetization_on),
                Text("Setup the payment")
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
                    color: dashbordColor,
                    child: GridView.count(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 20,
                      crossAxisCount: 1,
                      childAspectRatio: (itemWidth / itemHeight),
                      children: <Widget>[
                        CardWidget(
                          title: '  5MB',
                          subTitle: 'LKR 2',
                          img: 'assets/payhere.png',
                          notConnected: '',
                          unavailable: '',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "5")
                              : null,
                        ),
                        CardWidget(
                          title: '10MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "10")
                              : null,
                        ),
                        CardWidget(
                          title: '15MB',
                          subTitle: 'LKR 7',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "15")
                              : null,
                        ),
                        CardWidget(
                          title: '20MB',
                          subTitle: 'LKR 10',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "20")
                              : null,
                        ),
                        CardWidget(
                          title: '25MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "25")
                              : null,
                        ),
                        CardWidget(
                          title: '30MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "30")
                              : null,
                        ),
                        CardWidget(
                          title: '35MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "35")
                              : null,
                        ),
                        CardWidget(
                          title: '40MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "40")
                              : null,
                        ),
                        CardWidget(
                          title: '45MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "45")
                              : null,
                        ),
                        CardWidget(
                          title: '50MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "50")
                              : null,
                        ),
                        CardWidget(
                          title: '55MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "55")
                              : null,
                        ),
                        CardWidget(
                          title: '60MB',
                          subTitle: 'LKR 5',
                          notConnected: '',
                          unavailable: '',
                          img: 'assets/payhere.png',
                          onClick: snapshot.data["merchantId"] &&
                                  snapshot.data["merchantSecret"]
                              ? () => modalWidget(context, "60")
                              : null,
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
  final String img;
  final String unavailable;
  final String notConnected;
  final onClick;

  CardWidget(
      {this.subTitle,
      this.onClick,
      this.img,
      this.title,
      this.notConnected,
      this.unavailable});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Card(
        margin: EdgeInsets.only(right: 5, top: 5, left: 5, bottom: 5),
        elevation: 1,
        color: blueLightColors,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: InkWell(
            onTap: onClick,
            child: Row(
              children: <Widget>[
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Text(
                        title,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: textColors,
                              fontSize: 40,
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
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        unavailable,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: textColors,
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
                              color: textColors,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset(
                        img,
                        width: 135,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
