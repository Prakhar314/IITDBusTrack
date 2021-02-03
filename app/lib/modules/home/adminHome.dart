import 'package:app/modules/login/auth_service.dart';
import 'package:app/widgets/showSnackbarMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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
        body: AdminPageBody());
  }
}

class AdminPageBody extends StatefulWidget {
  const AdminPageBody({
    Key key,
  }) : super(key: key);

  @override
  _AdminPageBodyState createState() => _AdminPageBodyState();
}

class _AdminPageBodyState extends State<AdminPageBody> {
  bool loading = false;

  String error;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email', errorText: error),
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
                    showSnackbarMessage(context, setClaimResponse);
                    setState(() {
                      loading = false;
                    });
                  })
        ]),
      ),
    );
  }
}
