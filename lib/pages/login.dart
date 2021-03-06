import 'dart:convert';

import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/components/secondary-button.dart';
import 'package:bookbuddies/providers/location_provider.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordShown = false;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('@bb_user') ?? '';
    if (userId.length > 2) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
    }
  }

  void _onSubmit() async {
    _formKey.currentState?.save();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_formData['email'] == '' || _formData['password'] == '') {
      await showDialog(
          context: context,
          builder: (ctx) {
            return Dialog(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    Text('E-mail ou senha incorretos, tente novamente!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
            );
          });
    } else {
      setState(() {
        loading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _formData['email'] as String,
                password: _formData['password'] as String);
        await prefs.setString('@bb_user', userCredential.user?.uid ?? '');
        setState(() {
          loading = false;
        });
        Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          await showDialog(
              context: context,
              builder: (ctx) {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        Text('E-mail ou senha incorretos, tente novamente',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  ),
                );
              });

          setState(() {
            loading = false;
          });
        } else if (e.code == 'wrong-password') {
          await showDialog(
              context: context,
              builder: (ctx) {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        Text('E-mail ou senha incorretos, tente novamente',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  ),
                );
              });
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadUser();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/login.png"),
          fit: BoxFit.cover,
        )),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.length < 3 ||
                              !value.contains('@')) {
                            return 'Entre seu email corretamente';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (email) {
                          _formData['email'] = email ?? '';
                          // locationProvider.getLocation();
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Color(0xFFC41212),
                            ),
                          ),
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Seu e-mail',
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Color(0xFFC41212),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF909A9E),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusColor: Color(0xff909A9E),
                          errorStyle: TextStyle(color: Color(0xFFC41212)),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Color(0xFFC41212),
                            ),
                          ),
                          prefixIcon: Icon(Icons.vpn_key_rounded),
                          suffixIcon: IconButton(
                            icon: isPasswordShown
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isPasswordShown = !isPasswordShown;
                              });
                            },
                          ),
                          labelText: 'Senha',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF909A9E),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Color(0xFFC41212),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusColor: Color(0xff909A9E),
                          errorStyle: TextStyle(color: Color(0xFFC41212)),
                          fillColor: Color(0xFF909A9E),
                          alignLabelWithHint: false,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        autocorrect: false,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Senha inv??lida';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (password) =>
                            _formData['password'] = password ?? '',
                        obscureText: !isPasswordShown,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      PrimaryButton(
                        title: 'ENTRAR',
                        loading: loading,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            _onSubmit();
                          }
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SecondaryButton(
                          title: 'CADASTRAR',
                          onPress: () {
                            Navigator.of(context).pushNamed(AppRoutes.SIGNUP);
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
