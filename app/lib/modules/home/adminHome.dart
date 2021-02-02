import 'package:app/modules/login/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool loading = false;

  String error;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => context.read<AuthenticationService>().signOut(),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration:
                    InputDecoration(labelText: 'Email', errorText: error),
              ),
              loading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text('Set Driver'),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        var setClaimResponse = await context
                            .read<AuthenticationService>()
                            .setUserClaim(email: emailController.text.trim());
                        if (setClaimResponse !=
                            AuthenticationService.setClaimText) {
                          setState(() {
                            loading = false;
                            error = setClaimResponse;
                          });
                        }
                      })
            ]),
          ),
        ));
  }
}
