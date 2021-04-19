import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  final int index;
  UserDetailsPage(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pakage details'),
      ),
      body: Center(
        child: Text('details #$index'),
      ),
    );
  }
}
