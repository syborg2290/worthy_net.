import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:worthy_net/pages/Login_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/widgets/Button_widget.dart';
import 'package:worthy_net/widgets/Header_container.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Register"),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: <Widget>[
                    textInput(hint: "First Name", icon: Icons.person),
                    textInput(hint: "Last Name", icon: Icons.person),
                    textInput(hint: "Email", icon: Icons.email),
                    textInput(hint: "Phone Number", icon: Icons.phone),
                    textInput(hint: "Password", icon: Icons.vpn_key),
                    textInput(
                        hint: "Confirm Password", icon: Icons.vpn_key_rounded),
                    Expanded(
                      child: Center(
                        child: ButtonWidget(
                          onClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          btnText: "REGISTER",
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Already a member ?",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(color: blueColors),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // input widget
  Widget textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
