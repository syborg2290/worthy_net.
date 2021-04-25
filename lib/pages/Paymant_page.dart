import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worthy_net/config/collections.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/widgets/Button_widget.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as KeyGet;

class PymantPage extends StatefulWidget {
  @override
  _PymantPageState createState() => _PymantPageState();
}

class _PymantPageState extends State<PymantPage> {
  TextEditingController merchantId = new TextEditingController();
  TextEditingController merchantSec = new TextEditingController();
  bool isLoading = false;

  setPaymentDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      if (merchantId.text != "") {
        if (merchantSec.text != "") {
          final key = KeyGet.Key.fromUtf8('ghjklsgdferty27364uyrhjskytrghso');
          final iv = IV.fromLength(16);

          final encrypter = Encrypter(AES(key));
          try {
            setState(() {
              isLoading = true;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var result = await usersRef
                .where("email", isEqualTo: prefs.getString("email"))
                .get();

            if (result.docs.length > 0) {
              await usersRef.doc(result.docs[0].id).update({
                "merchantId":
                    encrypter.encrypt(merchantId.text.trim(), iv: iv).base64,
                "merchantSecret":
                    encrypter.encrypt(merchantSec.text.trim(), iv: iv).base64,
              }).then((_) async => {
                    await prefs
                        .setString(
                            "merchantId",
                            encrypter
                                .encrypt(merchantId.text.trim(), iv: iv)
                                .base64)
                        .then((_) => {
                              setState(() {
                                isLoading = false;
                              }),
                              Navigator.pop(context)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: modalColor,
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: Text(''),
        ),
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            Container(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: dashbordColor,
                  elevation: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/payhere.png',
                        width: 250,
                        height: 250,
                      ),
                      const ListTile(
                        title: Text('Get Paid Online',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                            )),
                        subtitle: Text('Quickly. Securely. Globally.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                      ),
                      TextButton(
                        child: Text('Go to the site'),
                        style: TextButton.styleFrom(
                          primary: textColors,
                          backgroundColor: blueLightColors,
                        ),
                        onPressed: aunchURL,
                      ),
                    ],
                  )),
            ),
            Container(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Text('sdfsf', style: TextStyle(fontSize: 20)),
                  textInput(
                      controller: merchantId,
                      hint: "merchant id",
                      icon: Icons.military_tech_sharp),
                  textInput(
                      controller: merchantSec,
                      hint: "merchant secret",
                      icon: Icons.mobile_screen_share_rounded),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ButtonWidget(
                            btnText: 'Submit',
                            onClick: () => setPaymentDetails(),
                          ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  //page url
  aunchURL() async {
    const url =
        'https://www.payhere.lk/?gclid=Cj0KCQjw9_mDBhCGARIsAN3PaFOcCNnmQHkSdbFm0r22trwbSQYsSH_RwD8l7-uWc3hg_9o0tSYwE_oaAhl1EALw_wcB';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // input widget
  Widget textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: hint, prefixIcon: Icon(icon)),
      ),
    );
  }
}
