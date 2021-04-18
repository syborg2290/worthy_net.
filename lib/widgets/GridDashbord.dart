import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worthy_net/utils/Color.dart';

class GridDashbor extends StatelessWidget {
  Item item1 = new Item(
    title: "User",
    // subtitle: "",
    // event: "1event",
    img: "assets/host.png",
  );
  Item item2 = new Item(
    title: "Host",
    // subtitle: "",
    // event: "2event",
    img: "assets/user.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Item> myList = [item1, item2];
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return Container(
              decoration: BoxDecoration(
                  color: blueLightColors,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    data.img,
                    width:80,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: textColors,
                            fontSize: 25,
                            fontWeight: FontWeight.w600)),
                  ),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  // Text(
                  //   data.subtitle,
                  //   style: GoogleFonts.openSans(
                  //       textStyle: TextStyle(
                  //           color: textColors,
                  //           fontSize: 10,
                  //           fontWeight: FontWeight.w600)),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Text(
                  //   data.event,
                  //   style: GoogleFonts.openSans(
                  //       textStyle: TextStyle(
                  //           color: textColors,
                  //           fontSize: 10,
                  //           fontWeight: FontWeight.w600)),
                  // ),
                ],
              ),
            );
          }).toList()),
    );
  }
}

class Item {
  String title;
  // String subtitle;
  // String event;
  String img;
  Item({this.title, this.img});
}
