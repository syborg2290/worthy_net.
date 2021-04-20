import 'package:flutter/material.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/widgets/Button_widget.dart';
import 'package:worthy_net/widgets/Header_container.dart';

class HostDataPackagePage extends StatefulWidget {
  @override
  _HostDayaPackagePageState createState() => _HostDayaPackagePageState();
}

class _HostDayaPackagePageState extends State<HostDataPackagePage> {
  TextEditingController hostPasswordControlier = new TextEditingController();
  String hostPW = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Package active',
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer(""),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: <Widget>[
                    textInput(
                        controller: hostPasswordControlier,
                        hint: "Hosport password",
                        icon: Icons.wifi_lock_rounded),
                    Text(hostPW, style: TextStyle(color: validationColors)),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Pleace enter your mobile hosport password",
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child:ButtonWidget(
                                onClick: () {
                                },
                                btnText: "Active",
                              ),
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
