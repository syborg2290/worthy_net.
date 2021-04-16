import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:worthy_net/pages/Home_page.dart';
import 'package:worthy_net/pages/Register_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/widgets/Button_widget.dart';
import 'package:worthy_net/widgets/Header_container.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String valEmail = "";
  String valPassword = "";

//login function
  login() {
    if (emailController.text == "") {
      setState(() {
        valEmail = "Email is required.";
      });
    } else {
      if (passwordController.text == "") {
        setState(() {
          valPassword = "Password is required.";
        });
      }
      if (emailController.text != "") {
        setState(() {
          // print(emailController.text);
          valEmail = "";
        });
      }
      if (passwordController.text != "") {
        setState(() {
          // print(passwordController.text);
          valPassword = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Login"),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: <Widget>[
                    textInput(
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.email),
                    Text(valEmail, style: TextStyle(color: validationColors)),
                    passwordInput(
                        controller: passwordController,
                        hint: "Password",
                        icon: Icons.vpn_key),
                    Text(valPassword,
                        style: TextStyle(color: validationColors)),
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
                        child: ButtonWidget(
                          onClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                            login();
                          },
                          btnText: "LOGIN",
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
                          style: TextStyle(color: blueColors),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
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

  Widget passwordInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: hint, prefixIcon: Icon(icon)),
      ),
    );
  }
}
