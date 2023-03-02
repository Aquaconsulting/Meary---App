import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/api.dart';
import 'package:meari/main.dart';
import 'package:meari/pages/home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loginUser() async {
    // setState(() {
    //   loading = true;
    // });
    final data = {
      'email': mailController.text.toString(),
      'password': passwordController.text.toString(),
    };
    //chiamata api in post
    final result = await API().postRequest(route: 'login', data: data);
    print(result);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('id', response['user'][0]['id']);
      await preferences.setString('name', response['user'][0]['first_name']);
      await preferences.setString('email', response['user'][0]['email']);
      await preferences.setString('token', response['token']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Color(0xFF000000)),
                controller: mailController,
                cursorColor: const Color(0xFF9b9b9b),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                  ),
                  hintText: "Email",
                  hintStyle: TextStyle(
                      color: Color(0xFF9b9b9b),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
              TextField(
                style: const TextStyle(color: Color(0xFF000000)),
                cursorColor: const Color(0xFF9b9b9b),
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: Colors.grey,
                  ),
                  hintText: "Password",
                  hintStyle: TextStyle(
                      color: Color(0xFF9b9b9b),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
              ElevatedButton(
                  onPressed: loading ? null : loginUser,
                  child:
                      loading ? const Text('Loading...') : const Text('Login')),
            ],
          )),
    );
  }
}
