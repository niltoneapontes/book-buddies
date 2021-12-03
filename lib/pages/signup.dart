import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordShown = false;
  bool isConfirmPasswordShown = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cadastre-se'),
        flexibleSpace: Image(
          image: AssetImage('assets/header.png'),
          fit: BoxFit.fill,
          alignment: Alignment.bottomCenter,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Entre seu nome completo';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Nome completo',
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.length < 3 ||
                        !value.contains('@')) {
                      return 'Entre seu e-mail';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    labelText: 'E-mail',
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Entre seu telefone no formato (DDD) XXXXX-XXXX';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Telefone',
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Senha inválida';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key_rounded),
                    labelText: 'Senha',
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                  obscureText: !isPasswordShown,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key_rounded),
                    labelText: 'Confirme sua senha',
                    suffixIcon: IconButton(
                      icon: isConfirmPasswordShown
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordShown = !isConfirmPasswordShown;
                        });
                      },
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                  obscureText: !isConfirmPasswordShown,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24),
                PrimaryButton(
                    title: 'CADASTRAR',
                    onPress: () {
                      Navigator.of(context).pushNamed(AppRoutes.LOGIN);
                    }),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
