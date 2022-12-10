import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worthy_net/config/collections.dart';
import 'package:worthy_net/pages/Home_page.dart';
import 'package:worthy_net/pages/Register_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/widgets/Button_widget.dart';
import 'package:worthy_net/widgets/Header_container.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as KeyGet;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;

  String valEmail = "";
  String valPassword = "";

//login function
  login() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      if (emailController.text == "") {
        setState(() {
          valEmail = "Email is required.";
        });
      } else {
        if (passwordController.text == "") {
          setState(() {
            valPassword = "Password is required.";
          });
        } else {
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

          try {
            setState(() {
              isLoading = true;
            });
            var result = await usersRef
                .where("email", isEqualTo: emailController.text.trim())
                .get();

            if (result.docs.length > 0) {
              final key =
                  KeyGet.Key.fromUtf8('ghjklsgdferty27364uyrhjskytrghso');
              final iv = IV.fromLength(16);

              final encrypter = Encrypter(AES(key));
              var resultPass = await usersRef
                  .where("password",
                      isEqualTo: encrypter
                          .encrypt(passwordController.text.trim(), iv: iv)
                          .base64)
                  .get();
              if (resultPass.docs.length > 0) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString("email", emailController.text).then((_) =>
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()))
                    });
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Info',
                  desc: 'Password not matched with any email address!',
                  btnCancel: Text(""),
                  btnOk: Text(""),
                )..show();

                setState(() {
                  isLoading = false;
                });
              }
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Info',
                desc: 'Email address not matched with any account!',
                btnCancel: Text(""),
                btnOk: Text(""),
              )..show();

              setState(() {
                isLoading = false;
              });
            }
          } catch (e) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Info',
              desc: e.toString(),
              btnCancel: Text(""),
              btnOk: Text(""),
            )..show();
            setState(() {
              isLoading = false;
            });
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(3.0), // here the desired height
          child: AppBar(
            automaticallyImplyLeading: false,
          )),
      body: WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: Container(
          // padding: EdgeInsets.only(bottom: 10),
          child: ListView(
            children: <Widget>[
              HeaderContainer("Login"),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 40),
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
                    Container(
                      padding: EdgeInsets.only(top: 50, bottom: 10),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: blueColors,
                              ),
                            )
                          : Center(
                              child: ButtonWidget(
                                onClick: () {
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
                          style: TextStyle(
                            color: blueColors,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
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
            ],
          ),
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
