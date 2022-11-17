import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kgx_attendance/api/ApiService.dart';
import 'package:kgx_attendance/api/attendanceapi.dart';
import 'package:kgx_attendance/views/qrbuttons.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  var token;
  late String finalEmail;
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(Duration(seconds: 2),
          () => Get.to(finalEmail == null ? LoginPage() : QrButtons()));
    });
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var gotmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = gotmail!;
    });
    print(finalEmail);
  }

  callLoginApi() {
    final service = ApiServices();

    service.apiCallLogin(
      {
        "username": emailText.text,
        "password": passwordText.text,
      },
    ).then((value) {
      if (value.error != null) {
        print("get data >>>>>> " + value.error!);
        const snackBar = SnackBar(
          content: Text(
            'Enter valid credentials',
            style: TextStyle(fontFamily: 'SpecialElite'),
          ),
          backgroundColor: Color.fromRGBO(75, 68, 216, 10.0),
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        token = value.access_token;
        print(token);
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => QrButtons())));
        const snackBar = SnackBar(
          content: Text(
            'Login Successful!',
            style: TextStyle(fontFamily: 'SpecialElite'),
          ),
          backgroundColor: Color.fromRGBO(75, 68, 216, 10.0),
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      // ignore: avoid_unnecessary_containers
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Image.asset(
                'assets/images/kgx-logo.png',
                height: 90,
                width: 100,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              child: const Text(
                'KGX Attendance',
                style: TextStyle(fontSize: 30, fontFamily: 'Alata-Regular'),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: TextField(
                controller: emailText,
                style: const TextStyle(fontFamily: 'Alata-Regular'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  labelText: 'Email/Username',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: passwordText,
                style: const TextStyle(fontFamily: 'Alata-Regular'),
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 80,
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    primary: Color.fromRGBO(80, 72, 229, 10.0),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontFamily: 'Alata-Regular'),
                  ),
                  onPressed: () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString('email', emailText.text);
                    callLoginApi();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
