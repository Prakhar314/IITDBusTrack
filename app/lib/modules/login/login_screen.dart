import 'package:app/modules/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool signingin = false;
  String error;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email', errorText: error),
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          Padding(padding: EdgeInsets.all(8)),
          signingin
              ? CircularProgressIndicator()
              : Row(
                  children: [
                    RaisedButton(
                        child: Text('Sign In'),
                        onPressed: () async {
                          setState(() {
                            signingin = true;
                          });
                          var signinResponse = await context
                              .read<AuthenticationService>()
                              .signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text);
                          if (signinResponse !=
                              AuthenticationService.signInText) {
                            setState(() {
                              signingin = false;
                              error = signinResponse;
                            });
                          }
                        }),
                    RaisedButton(
                        child: Text('Sign Up'),
                        onPressed: () async {
                          setState(() {
                            signingin = true;
                          });
                          var signupResponse = await context
                              .read<AuthenticationService>()
                              .signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text);
                          if (signupResponse !=
                              AuthenticationService.signUpText) {
                            setState(() {
                              signingin = false;
                              error = signupResponse;
                            });
                          }
                        }),
                  ],
                )
        ]),
      ),
    );
  }
}
