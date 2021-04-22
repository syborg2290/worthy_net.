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
  List<WifiNetwork> wifiNetworks;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    SimplyWifi.init();
    SimplyWifi.turnOnWifi();
    getListOfWifiAvailable();
  }

  getListOfWifiAvailable() async {
    // To get the list of Wifis
    List<WifiNetwork> _wifiNetworks = await SimplyWifi.getListOfWifis();
    List<WifiNetwork> _wifiFiltered = [];

    for (var i = 0; i < _wifiNetworks.length; i++) {
      var result = await usersRef
          .where("ssid", isEqualTo: _wifiNetworks[i].ssid.toLowerCase())
          .get();
      if (result.docs.length > 0) {
        _wifiFiltered.add(_wifiNetworks[i]);
      }
    }
    setState(() {
      wifiNetworks = _wifiFiltered;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of all hosts',
        ),
      ),
      body: isLoading
          ? Center(child: Image.asset("assets/radar.gif"))
          : wifiNetworks.length <= 0
              ? Center(
                  child: Column(
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserDetailsPage(index)),
            );
          },
        );
      },
    );
  }
}
