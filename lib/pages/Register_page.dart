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
  String valFirstName = "";
  String valLastName = "";
  String valEmail = "";
  String valPhone = "";
  String valPW = "";
  String valCPW = "";
  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController pwController = new TextEditingController();
  TextEditingController cpwController = new TextEditingController();

//register function
  register() {
    if (fNameController.text == "") {
      setState(() {
        valFirstName = "Enter your frist name";
      });
    } else {
      if (lNameController.text == "") {
        setState(() {
          valLastName = "Enter your last name";
        });
      } else {
        if (emailController.text == "") {
          setState(() {
            valEmail = "Enter your email";
          });
        } else {
          if (phoneController.text == "") {
            setState(() {
              valPhone = "Enter your phone number";
            });
          } else {
            if (pwController.text == "") {
              setState(() {
                valPW = "Enter your password";
              });
            } else {
              if (pwController.text != cpwController.text) {
                setState(() {
                  valCPW = "Passwords are not matched";
                });
              }
            }
          }
        }
      }
    }
    if (fNameController.text != "") {
      setState(() {
        valFirstName = "";
      });
    }
    if (lNameController.text != "") {
      setState(() {
        valLastName = "";
      });
    }
    if (emailController.text != "") {
      setState(() {
        valEmail = "";
      });
    }
    if (phoneController.text != "") {
      setState(() {
        valPhone = "";
      });
    }
    if (pwController.text != "") {
      setState(() {
        valPW = "";
      });
    }
    if (pwController.text == cpwController.text && cpwController.text != "") {
      setState(() {
        valCPW = "";
      });
    }
  }

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
                //column
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    textInput(
                        controller: fNameController,
                        hint: "First Name",
                        icon: Icons.person),
                    Text(valFirstName,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: validationColors)),
                    textInput(
                        controller: lNameController,
                        hint: "Last Name",
                        icon: Icons.person),
                    Text(valLastName,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: validationColors)),
                    textInput(
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.email),
                    Text(valEmail,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: validationColors)),
                    numbersdInput(
                        controller: phoneController,
                        hint: "Phone Number",
                        icon: Icons.phone),
                    Text(valPhone,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: validationColors)),
                    passwordInput(
                      controller: pwController,
                      hint: "Password",
                      icon: Icons.vpn_key,
                    ),
                    Text(valPW,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: validationColors)),
                    passwordInput(
                        controller: cpwController,
                        hint: "Confirm Password",
                        icon: Icons.vpn_key_rounded),
                    Text(valCPW,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: validationColors)),
                    Expanded(
                      child: Center(
                        child: ButtonWidget(
                          onClick: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => LoginPage()));
                            register(); //register function
                          },
                          btnText: "REGISTER",
                        ),
                      ),
                    ),
                    Center(
                      child: RichText(
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

  Widget numbersdInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: hint, prefixIcon: Icon(icon)),
      ),
    );
  }
}
