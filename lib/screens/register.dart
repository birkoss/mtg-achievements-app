import 'package:flutter/material.dart';

import '../screens/login.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';

  Future<void> submit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 120),
                decoration: BoxDecoration(color: Colors.red),
                child: Text('Logo'),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.green),
                child: Text('Form'),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
