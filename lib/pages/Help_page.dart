import 'package:flutter/material.dart';
import 'package:worthy_net/utils/Color.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(''),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                SelectableText(
                  "Copy this app Domain name and go to the payhere web page",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  onTap: () {
                    // you can show toast to the user, like "Copied"
                  },
                ),
                SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "com.example.worthy_net",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/screenshot1.png',
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                SelectableText("paste domain name ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ],
            ),
          ),
          Container(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/screenshot2.png',
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                SelectableText("Copy your merchant id and merchant secret",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ],
            ),
          ),
          Container(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/screenshot3.png',
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                SelectableText("Paste your merchant id and merchant secret",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ],
            ),
          ),
          Container(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/screenshot4.png',
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}
