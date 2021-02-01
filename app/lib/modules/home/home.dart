import 'package:app/modules/home/userHome.dart';
import 'package:app/modules/login/auth_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'driverHome.dart';

class HomePage extends StatelessWidget {
  static const route = '/';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<AuthenticationService>().waitForCustomClaims(),
      builder: (context, AsyncSnapshot<IdTokenResult> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.claims.containsKey('driver') &&
              snapshot.data.claims['driver']) {
            return DriverHome();
          } else {
            return UserHome();
          }
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
