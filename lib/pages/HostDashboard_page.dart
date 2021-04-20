import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/pages/HostDataPackage_page.dart';
import 'package:worthy_net/utils/Color.dart';

class HostDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // data package card media query
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data package',
        ),
      ),
      body: Container(
        color: dashbordColor,
        child: GridView.count(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 1,
          childAspectRatio: (itemWidth / itemHeight),
          children: <Widget>[
            CardWidget(
              title: '5MB',
              subTitle: 'LKR 1',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '10MB',
              subTitle: 'LKR 2',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '15MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '20MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '25MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '30MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '35MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '40MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '45MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '50MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '55MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
            CardWidget(
              title: '60MB',
              subTitle: 'LKR 5',
              img: 'assets/user.png',
              onClick: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HostDataPackagePage()))
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String subTitle;
  final String title;
  final String img;
  final onClick;

  CardWidget({this.subTitle, this.onClick, this.img, this.title});

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                title,
                textAlign: TextAlign.end,
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: textColors,
                        fontSize: 40,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                subTitle,
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: textColors,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              ),
              Image.asset(
                img,
                width: 150,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
