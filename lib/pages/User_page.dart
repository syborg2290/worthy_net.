import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:worthy_net/config/collections.dart';
import 'package:worthy_net/pages/UserDetails_page.dart';
import 'package:simply_wifi/simply_wifi.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<WifiNetwork> wifiNetworks = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    SimplyWifi.init().then(
      (intV) => {
        if (intV)
          {
            SimplyWifi.turnOnWifi().then(
              (value) => {getListOfWifiAvailable()},
            )
          }
      },
    );
  }

  getListOfWifiAvailable() async {
    // To get the list of Wifis
    List<WifiNetwork> _wifiNetworks = await SimplyWifi.getListOfWifis();

    for (var i = 0; i < _wifiNetworks.length; i++) {
      await getUserDocUsingSsid(_wifiNetworks[i]);
    }
  }

  getUserDocUsingSsid(WifiNetwork wifiNetworksRe) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      try {
        var result =
            await usersRef.where("ssid", isEqualTo: wifiNetworksRe.ssid).get();

        if (result.docs.length > 0) {
          if (wifiNetworks
              .where((ele) => ele.ssid == wifiNetworksRe.ssid)
              .toList()
              .isEmpty) {
            wifiNetworks.add(wifiNetworksRe);
          }
        }

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
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

  getUserDetailsFromSsidAndNavigate(String ssid, int index) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      var result = await usersRef.where("ssid", isEqualTo: ssid).get();
      if (result.docs.length > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsPage(
              index,
              result.docs[0].data()["email"],
              result.docs[0].id,
              ssid.toLowerCase(),
              result.docs[0].data()["hotspot_password"],
              result.docs[0].data()["merchantId"],
              result.docs[0].data()["merchantSecret"],
            ),
          ),
        );
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
      appBar: AppBar(
        title: Text(
          'List of all hosts',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          SimplyWifi.turnOnWifi().then(
            (value) => {getListOfWifiAvailable()},
          );
        },
        strokeWidth: 4.0,
        child: Column(
          children:<Widget> [
            Row(
              children:<Widget> [
                Container(
                  child: isLoading
                      ? Center(child: Image.asset("assets/radar.gif"))
                      : wifiNetworks.length <= 0
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/empty_hosts.png",
                                ),
                                Text(""),
                                Text(
                                  "Empty hosts",
                                  style: TextStyle(fontSize: 40, color: Colors.grey),
                                )
                              ],
                            ))
                          : buildListView(context, wifiNetworks),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                 Container(
                    // margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton.icon(
                      label: Text(''),
                      icon: Icon(Icons.refresh),
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        onPrimary: Colors.black,
                        // onSurface: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      
      ),
    );
  }

  ListView buildListView(BuildContext context, List<WifiNetwork> listWifi) {
    return ListView.builder(
      itemCount: listWifi?.length,
      itemBuilder: (_, index) {
        return ListTile(
            title: Text(listWifi[index]?.ssid),
            subtitle: Text(listWifi[index]?.bssid.toString()),
            leading: Icon(
              Icons.wifi,
              color: Colors.blue,
              size: 40.0,
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => getUserDetailsFromSsidAndNavigate(
                listWifi[index]?.ssid, index));
      },
    );
  }
}
