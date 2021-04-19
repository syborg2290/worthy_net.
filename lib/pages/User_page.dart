import 'package:flutter/material.dart';
import 'package:worthy_net/pages/UserDetails_page.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List vew',
        ),
      ),
      body: buildListView(context),
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text('Ther list item #$index'),
          subtitle: Text('Sub title'),
          leading: Icon(Icons.thumb_up),
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
