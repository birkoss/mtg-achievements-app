import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/register.dart';

import '../models/http_exception.dart';

import '../providers/user.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _formValues = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _formSubmitted() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .login(_formValues['email'], _formValues['password']);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Cound not authenticate you. Please try later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                width: width,
                height: height * 0.30,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'MTG Achievements',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      color:
                          Theme.of(context).primaryTextTheme.headline1.color),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Invalid Email!';
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              _formValues['email'] = newValue,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty || value.length < 8) {
                              return 'Invalid Password! Must be at least 8 characters!';
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              _formValues['password'] = newValue,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Text('LOGIN'),
                          onPressed: _formSubmitted,
                        ),
                        TextButton(
                          child: Text('Forgot your password?'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(RegisterScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: TextButton(
                  child: Text('Don\'t have an account? Register'),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegisterScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
