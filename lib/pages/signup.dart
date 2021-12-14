import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/components/secondary-button.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordShown = false;
  bool isConfirmPasswordShown = false;
  bool showForm = true;

  final _formData = Map<String, Object>();
  final _formKey = GlobalKey<FormState>();
  final _codeKey = GlobalKey<FormState>();

  String verificationCode = '';
  String loadedVerificationId = '';

  void _verifyCode(phone) async {
    _formKey.currentState?.save();

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+55$phone',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          User? current = FirebaseAuth.instance.currentUser;
          current?.updatePhoneNumber(authCredential);
          Navigator.of(context).pushNamed(AppRoutes.HOME);
        },
        verificationFailed: (FirebaseAuthException e) async {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            loadedVerificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (_) async {
          print('Auto Retrieval Timeout');
        });
  }

  void _onSubmit(phone) async {
    _codeKey.currentState?.save();

    if (verificationCode != '') {
      try {
        final credential = PhoneAuthProvider.credential(
            verificationId: loadedVerificationId, smsCode: verificationCode);
        User? current = FirebaseAuth.instance.currentUser;
        await current?.updatePhoneNumber(credential);
        Navigator.of(context).pushNamed(AppRoutes.HOME);
      } on FirebaseAuthException catch (e) {
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
                      Text('Código incorreto, tente novamente',
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
      }
    } else {
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
                    Text('Código incorreto, tente novamente',
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
    }
  }

  void _signUp() async {
    _formKey.currentState?.save();

    if (_formData['confirmPassword'] == '') {
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
                    Text('Preencha os dados corretamente',
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
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _formData['email'] as String,
        password: _formData['confirmPassword'] as String,
      );
      User? current = FirebaseAuth.instance.currentUser;
      current?.updateDisplayName(_formData['name'] as String);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
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
                      Text('Senha é muito fraca',
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
      } else if (e.code == 'email-already-in-use') {
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
                      Text('Já existe uma conta com esse e-mail',
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
      }
      _verifyCode(_formData['phone'] as String);
      setState(() {
        showForm = false;
      });
    } catch (e) {
      print('Unidentified Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return showForm
        ? Scaffold(
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        onSaved: (newValue) =>
                            _formData['name'] = newValue ?? '',
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Nome e sobrenome',
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
                        onSaved: (newValue) =>
                            _formData['email'] = newValue ?? '',
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
                        onSaved: (newValue) =>
                            _formData['phone'] = newValue ?? '',
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
                        onSaved: (newValue) =>
                            _formData['password'] = newValue ?? '',
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
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Senha inválida';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key_rounded),
                          labelText: 'Confirme sua senha',
                          suffixIcon: IconButton(
                            icon: isConfirmPasswordShown
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordShown =
                                    !isConfirmPasswordShown;
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
                        onSaved: (newValue) =>
                            _formData['confirmPassword'] = newValue ?? '',
                        obscureText: !isConfirmPasswordShown,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: 24),
                      PrimaryButton(
                          title: 'CADASTRAR',
                          onPress: () {
                            _signUp();
                          }),
                    ],
                  ),
                ),
              )),
            ),
          )
        : Scaffold(
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
                        key: _codeKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 12,
                              ),
                              child: Text(
                                'Insira o código que enviamos para o seu celular',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 24,
                              ),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 6,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(8),
                                  fieldHeight: 60,
                                  fieldWidth: 40,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    verificationCode = value;
                                  });
                                },
                              ),
                            ),
                            PrimaryButton(
                              title: 'CONFIRMAR',
                              onPress: () => _onSubmit(_formData['phone']),
                            ),
                            SecondaryButton(
                                title: 'REENVIAR',
                                onPress: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.SIGNUP);
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
