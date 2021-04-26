import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/pages/User_page.dart';
import 'package:worthy_net/utils/Color.dart';
import 'package:worthy_net/pages/HostDashboard_page.dart';

class GridDashbor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      CardWidget(
        img: 'assets/user.png',
        title: 'User',
        //user page load
        onClick: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserPage()))
        },
      ),
      CardWidget(
        img: 'assets/host.png',
        title: 'Host',
        //Host page load
        onClick: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HostDashboardPage()))
        },
      ),
    ]);
  }
}

class CardWidget extends StatelessWidget {
  final String img;
  final String title;
  final onClick;

  CardWidget({this.img, this.onClick, this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      color: blueLightColors,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: InkWell(
          onTap: onClick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                img,
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                title,
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: textColors,
                        fontSize: 25,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
