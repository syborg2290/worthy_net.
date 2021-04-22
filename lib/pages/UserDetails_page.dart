import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/utils/Color.dart';

class UserDetailsPage extends StatelessWidget {
  final int index;
  UserDetailsPage(this.index);

  @override
  Widget build(BuildContext context) {
    //mediaquery
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 8;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text('pakage details'),
      ),
      // child: Text('details #$index'),
      body: Container(
        color: packageCardColor,
        child: GridView.count(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 1,
          childAspectRatio: (itemWidth / itemHeight),
          children: <Widget>[
            CardWidget(
              title: '  5MB',
              subTitle: 'LKR 2',
              img: 'assets/payhere.png',
              notConnected: '',
              unavailable: '',
              onClick: () => {},
            ),
            CardWidget(
              title: '10MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '15MB',
              subTitle: 'LKR 7',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '20MB',
              subTitle: 'LKR 10',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '25MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '30MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '35MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '40MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '45MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '50MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '55MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
            CardWidget(
              title: '60MB',
              subTitle: 'LKR 5',
              notConnected: '',
              unavailable: '',
              img: 'assets/payhere.png',
              onClick: () => {},
            ),
          ],
        ),
      ),
    );
  }
}

//card widget
class CardWidget extends StatelessWidget {
  final String subTitle;
  final String title;
  final String img;
  final String unavailable;
  final String notConnected;
  final onClick;

  CardWidget(
      {this.subTitle,
      this.onClick,
      this.img,
      this.title,
      this.notConnected,
      this.unavailable});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Card(
        elevation: 10,
        color: blueLightColors,
        child: InkWell(
          onTap: onClick,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Text(
                      title,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: textColors,
                            fontSize: 40,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      subTitle,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: textColors,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      unavailable,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: unavailableColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      notConnected,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: notConnectedColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    // padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      img,
                      width: 130,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
