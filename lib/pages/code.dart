import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/components/secondary-button.dart';
import 'package:bookbuddies/pages/loading.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationCode extends StatefulWidget {
  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final _formKey = GlobalKey<FormState>();

  User current = FirebaseAuth.instance.currentUser as User;
  String verificationCode = '';
  String verificationId = '';

  void _verifyCode(phone) async {
    _formKey.currentState?.save();

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+55$phone',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          current.updatePhoneNumber(authCredential);
          print({'authCredential': authCredential});
          Navigator.of(context).pushNamed(AppRoutes.HOME);
        },
        verificationFailed: (FirebaseAuthException e) async {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          print('Code Sent');
          setState(() {
            verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (_) async {
          print('Auto Retrieval Timeout');
        });
  }

  void _onSubmit(phone) async {
    _formKey.currentState?.save();

    if (verificationCode != '') {
      try {
        print({verificationId, verificationCode});
        final credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: verificationCode);
        await current.updatePhoneNumber(credential);

        print({'credential': credential});
      } on FirebaseAuthException catch (e) {
        print('Error: Invalid Id');
        print({'error': e});
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

  @override
  Widget build(BuildContext context) {
    String phone = ModalRoute.of(context)!.settings.arguments as String;

    _verifyCode(phone);
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
                        onPress: () => _onSubmit(phone),
                      ),
                      SecondaryButton(
                          title: 'REENVIAR',
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
