import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:meari/api/api.dart';
import 'package:meari/api/data.dart';
import 'package:meari/components/customAppBar.dart';
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
        print(response['user'][0]['id']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(userID: response['user'][0]['id'])));
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
        backgroundColor: HexColor('#F4F3F3'),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                const Divider(color: Colors.black),
                const SizedBox(
                  height: 12,
                ),
                Form(
                    // autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Color(0xFF000000)),
                          controller: mailController,
                          cursorColor: const Color(0xFF9b9b9b),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(8)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            fillColor: Colors.white,
                            filled: true,
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(8)),
                            labelStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xffaab8c2),
                            ),
                            labelText: 'Email',
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 40),
                            //labelText: "Password",
                            hintStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xffaab8c2),
                            ),
                          ),
                          validator: (value) {
                            isValid = EmailValidator.validate(value!);
                            if (isValid == false) {
                              return 'Inserisci una mail valida';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Color(0xFF000000)),
                          cursorColor: const Color(0xFF9b9b9b),
                          controller: passwordController,
                          obscureText: seePassword ? false : true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(8)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            fillColor: Colors.white,
                            filled: true,
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(8)),
                            labelStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xffaab8c2),
                            ),
                            labelText: 'Password',
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 40),
                            //labelText: "Password",
                            hintStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xffaab8c2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserisci la password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 60,
                          width: 320,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('#43ABFB')),
                              onPressed: loading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        loginUser();
                                        //funzione per chiudere la tastiera automaticamente
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      }
                                    },
                              child: loading
                                  ? const Text('Caricamento...')
                                  : const Text(
                                      'ACCEDI',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    )),
                        ),
                      ],
                    )),
                TextButton(
                    onPressed: (() {}),
                    child: const Text(
                      'Password dimenticata?',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(errorMessage != '' ? errorMessage : ''),
                )
              ],
            ),
          ),
        ));
  }
}
