import 'package:app/modules/home/adminHome.dart';
import 'package:app/modules/home/userHome.dart';
import '../data/dataProvider.dart';
import 'package:app/modules/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'driverHome.dart';

class HomePage extends StatelessWidget {
  static const route = '/';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.read<AuthenticationService>().userToken,
      builder: (context, child) => Consumer<UserToken>(
        builder: (bc, ut, child) {
          if (ut.tokenLoaded) {
            print(ut.token.claims);
            if (ut.token.claims.containsKey('admin') &&
                ut.token.claims['admin']) {
              return AdminHome();
            }
            if (ut.token.claims.containsKey('driver') &&
                ut.token.claims['driver']) {
              return DriverHome(new DataProvider(ut.token.token));
              // return DriverHome();
            }
            return UserHome(new DataProvider(ut.token.token));
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
