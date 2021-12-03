import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/components/secondary-button.dart';
import 'package:bookbuddies/models/login.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordShown = false;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  void _onSubmit() {
    _formKey.currentState?.save();

    final login = Login(
      name: _formData['email'] as String,
      password: _formData['password'] as String,
    );
    Navigator.of(context).pushNamed(AppRoutes.HOME);
  }

  @override
  Widget build(BuildContext context) {
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
                  autovalidateMode: AutovalidateMode.always,
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
                        onSaved: (email) => _formData['email'] = email ?? '',
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
                            return 'Senha inválida';
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
                        onPress: () => _onSubmit(),
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
