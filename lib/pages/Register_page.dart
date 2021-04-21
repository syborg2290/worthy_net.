import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worthy_net/config/collections.dart';
import 'package:worthy_net/pages/Home_page.dart';
import 'package:worthy_net/pages/Login_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/widgets/Button_widget.dart';
import 'package:worthy_net/widgets/Header_container.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as KeyGet;

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
  bool isLoading = false;
  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController pwController = new TextEditingController();
  TextEditingController cpwController = new TextEditingController();

//register function
  register() async {
    if (fNameController.text == "") {
      setState(() {
        valFirstName = "Enter your first name";
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
              } else {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  var result = await usersRef
                      .where("email", isEqualTo: emailController.text.trim())
                      .get();
                  if (result.docs.length > 0) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Info',
                      desc: 'Email address already in used!',
                      btnCancel: Text(""),
                      btnOk: Text(""),
                    )..show();

                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final key = KeyGet.Key.fromUtf8(
                        'ghjklsgdferty27364uyrhjskytrghso');
                    final iv = IV.fromLength(16);

                    final encrypter = Encrypter(AES(key));
                  
                    usersRef.add({
                      "fname": fNameController.text.trim(),
                      "lname": lNameController.text.trim(),
                      "email": emailController.text.trim(),
                      "phonenumber": phoneController.text.trim(),
                      "password": encrypter
                          .encrypt(pwController.text.trim(), iv: iv)
                          .base64,
                      "isConnected": false,
                      "merchantId": null,
                      "merchantSecret": null,
                      "ssid": null,
                      "hotspot_password": null,
                      "packages": {
                        "5": false,
                        "10": false,
                        "15": false,
                        "20": false,
                        "25": false,
                        "30": false,
                        "35": false,
                        "40": false,
                        "45": false,
                        "50": false,
                        "55": false,
                        "60": false,
                      }
                    }).then((_) async => {
                          await prefs
                              .setString("email", emailController.text)
                              .then((_) => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()))
                                  })
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(3.0), // here the desired height
          child: AppBar(
            automaticallyImplyLeading: false,
          )),
      // resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: ListView(
          children: <Widget>[
            HeaderContainer("Register"),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
              //Column
              //ListView
              child: Column(
                // shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
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
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    child: Center(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: blueColors,
                              ),
                            )
                          : ButtonWidget(
                              onClick: () {
                                register(); //register function
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
                        style: TextStyle(color: blueColors,fontWeight: FontWeight.w600,fontSize:17,),
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
          ],
        ),
      ),
    );
  }

  // input widget
  Widget textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top:0.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: hint, prefixIcon: Icon(icon)),
      ),
    );
  }

  Widget passwordInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 0.2),
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
      margin: EdgeInsets.only(top: 0.2),
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
