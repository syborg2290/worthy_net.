import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/utils/Color.dart';

class HeaderContainer extends StatelessWidget {
  var text = "";

  HeaderContainer(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColors, blueLightColors],
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter, //linearGradient
          ),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: Image.asset("assets/logo.png", width: 250, height: 250),
          ),
          // Center(
          //   child: Text(
          //     "Worthy Net",
          //     style: GoogleFonts.openSans(
          //         textStyle: TextStyle(
          //             color: textColors,
          //             fontSize: 28,
          //             fontWeight: FontWeight.bold)),
          //   ),
          // ),
        ],
      ),
    );
  }
}
