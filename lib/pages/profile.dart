import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPasswordShown = false;
  bool isConfirmPasswordShown = false;

  final _formKey = GlobalKey<FormState>();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meu perfil'),
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
                  initialValue: currentUser?.displayName,
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
                  initialValue: currentUser?.email,
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
                  initialValue: currentUser?.phoneNumber,
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
                    title: 'SALVAR',
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.HOME);
                      }
                    }),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
