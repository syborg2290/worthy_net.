import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/widgets/Button_widget.dart';

class PymantPage extends StatefulWidget {
  @override
  _PymantPageState createState() => _PymantPageState();
}

class _PymantPageState extends State<PymantPage> {
  TextEditingController emailController = new TextEditingController();
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
                      controller: emailController,
                      hint: "merchant id",
                      icon: Icons.military_tech_sharp),
                  textInput(
                      controller: emailController,
                      hint: "merchant secret",
                      icon: Icons.mobile_screen_share_rounded),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: ButtonWidget(
                      btnText:'Submit',
                      onClick: () => Navigator.pop(context),
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
