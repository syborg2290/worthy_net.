import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_wifi/simply_wifi.dart';
import 'package:worthy_net/config/collections.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:encrypt/encrypt.dart' as KeyGet;
import 'package:encrypt/encrypt.dart';

class UserDetailsPage extends StatefulWidget {
  final int index;
  final String email;
  final String userId;
  final String ssid;
  final String hotspassword;
  UserDetailsPage(
      this.index, this.email, this.userId, this.ssid, this.hotspassword);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  bool isLoading = false;

  connectToHotspot() async {
    final key = KeyGet.Key.fromUtf8('ghjklsgdferty27364uyrhjskytrghso');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    SimplyWifi.connectWifiByName(widget.ssid,
            password: encrypter.decrypt64(widget.hotspassword, iv: iv))
        .then((value) async => {
              if (value)
                {
                  await usersRef
                      .doc(widget.userId)
                      .update({"isConnected": true}).then(
                          (_) => {currentUserIsConnected()}),
                }
            });
  }

  currentUserIsConnected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await usersRef
        .where("email", isEqualTo: prefs.getString("email"))
        .get();
    if (result.docs.length > 0) {
      await usersRef.doc(result.docs[0].id).update({"isConnected": true});
    }
  }

  @override
  Widget build(BuildContext context) {
    //mediaquery
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 8;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text('package details'),
      ),
      // child: Text('details #$index'),
      body: Container(
        color: packageCardColor,
        child: GridView.count(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 1,
          childAspectRatio: (itemWidth / itemHeight),
          children: <Widget>[
            CardWidget(
              title: '  5MB',
              subTitle: 'LKR 2',
              notConnected: 'no  tConnected',
              unavailable: 'not Connected',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '10MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '15MB',
              subTitle: 'LKR 7',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '20MB',
              subTitle: 'LKR 10',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '25MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '30MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '35MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '40MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '45MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '50MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '55MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
            CardWidget(
              title: '60MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
              btnClick: () => {},
            ),
          ],
        ),
      ),
    );
  }
}

//card widget
class CardWidget extends StatelessWidget {
  final String subTitle;
  final String title;
  final btnClick;
  final String unavailable;
  final String notConnected;
  final onClick;

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
                            fontSize: 55,
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
                        label: Text('Disconnect'),
                        icon: Icon(Icons.wifi_off_outlined),
                        onPressed: btnClick,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          onPrimary: Colors.black,
                          // onSurface: Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        unavailable,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: unavailableColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        notConnected,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: notConnectedColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
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
