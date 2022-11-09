import 'package:flutter/material.dart';
import 'package:kgx_attendance/api/ApiService.dart';
import 'package:kgx_attendance/views/qrscanner.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  callLoginApi() {
    final service = ApiServices();

    service.apiCallLogin(
      {
        "email": emailText.text,
        "password": passwordText.text,
      },
    ).then((value) {
      if (value.error != null) {
        print("get data >>>>>> " + value.error!);
      } else {
        print(value.token);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QrScanner()));
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
                height: 100,
                width: 100,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              child: const Text(
                'KGXAttendance',
                style: TextStyle(fontSize: 20, fontFamily: 'Alata-Regular'),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontFamily: 'Alata-Regular'),
                  ),
                  onPressed: () {
                    if (emailText.text == '' || passwordText.text == '') {
                      const snackBar = SnackBar(
                        content: Text(
                          'Enter the credentials',
                          style: TextStyle(fontFamily: 'SpecialElite'),
                        ),
                        backgroundColor: Colors.blueAccent,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      callLoginApi();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const QrScanner())));
                      const snackBar = SnackBar(
                        content: Text('Logging in...'),
                        backgroundColor: Colors.blueAccent,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(10),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
