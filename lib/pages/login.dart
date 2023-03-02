import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:meari/api/api.dart';
import 'package:meari/main.dart';
import 'package:meari/pages/home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
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
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    final data = {
      'email': mailController.text.toString(),
      'password': passwordController.text.toString(),
    };
    //chiamata api in post
    try {
      final result = await API().postRequest(route: 'login', data: data);
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        errorMessage = 'Email o password errati.';
        loading = false;
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } on NoSuchMethodError catch (_) {
      errorMessage = 'Qualcosa è andato storto';
      loading = false;
    } on FlutterError catch (e) {
      errorMessage = 'Qualcosa è andato storto';
      loading = false;
    } on FormatException catch (_) {
      errorMessage = '';
      loading = false;
    }
  }

  //boolean per validazione email
  bool isValid = false;
  //boolean per vedere la password
  bool seePassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
              // autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
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
                    validator: (value) {
                      isValid = EmailValidator.validate(value!);
                      if (isValid == false) {
                        return 'Inserisci una mail valida';
                      }
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: const Color(0xFF9b9b9b),
                    controller: passwordController,
                    obscureText: seePassword ? false : true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye_sharp),
                        onPressed: () {
                          setState(() {
                            seePassword = !seePassword;
                          });
                        },
                      ),
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci la password';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                loginUser();
                                //funzione per chiudere la tastiera automaticamente
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                      child: loading
                          ? const Text('Caricamento...')
                          : const Text('Login')),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(errorMessage != '' ? errorMessage : ''),
                  )
                ],
              )),
        ));
  }
}
