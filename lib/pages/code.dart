import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/components/secondary-button.dart';
import 'package:bookbuddies/models/login.dart';
import 'package:bookbuddies/pages/loading.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationCode extends StatefulWidget {
  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final _formKey = GlobalKey<FormState>();
  String verificationCode = '';

  void _onSubmit() async {
    _formKey.currentState?.save();

    if (verificationCode == '1234') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoadingPage(),
        ),
      );

      var future = new Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.HOME);
      });
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
                          length: 4,
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
                        onPress: () => _onSubmit(),
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
