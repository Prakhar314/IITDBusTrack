import 'package:app/modules/login/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Driver'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => context.read<AuthenticationService>().signOut(),
            )
          ],
        ),
        body: Center(child: Text("Driver")));
  }
}
