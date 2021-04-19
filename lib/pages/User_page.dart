import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
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
    setState(() {
      wifiNetworks = _wifiNetworks;
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
