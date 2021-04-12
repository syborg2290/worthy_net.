import 'package:flutter/material.dart';
import 'package:worthy_net/utils/Color.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [orangeColors, orangeLightColors],
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter, //linearGradient
                  ),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100))),
              child: Center(
                child: Image.asset("assets/logo.png",width:100,height:100,),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: <Widget>[
                    textInput(hint: "Email", icon: Icons.email),
                    textInput(hint: "Password", icon: Icons.vpn_key),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: InkWell(
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [orangeColors, orangeLightColors],
                                  end: Alignment.centerLeft,
                                  begin: Alignment.centerRight, //linearGradient
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            alignment: Alignment.center,
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Don't have an account ?",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: "Register",
                            style: TextStyle(color: orangeColors)),
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
