import 'package:app/modules/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dataProvider.dart';

class UserHome extends StatefulWidget {

  final DataProvider dataProvider;

  const UserHome(this.dataProvider,{Key key}) : super(key: key);
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => context.read<AuthenticationService>().signOut(),
            )
          ],
        ),
        body: ChangeNotifierProvider.value(
          value: widget.dataProvider,
          child: Consumer<DataProvider>(
            builder: (ctx, dp, child) {})));
        
        );
  }
}
