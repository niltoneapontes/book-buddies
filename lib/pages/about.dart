import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isPasswordShown = false;
  bool isConfirmPasswordShown = false;

  RangeValues _currentRangeValues = const RangeValues(0, 5);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sobre o App'),
        flexibleSpace: Image(
          image: AssetImage('assets/header.png'),
          fit: BoxFit.fill,
          alignment: Alignment.bottomCenter,
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
        padding: EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Feito com ❤ pela Book Buddies',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text('Versão 1.0.0'),
          ],
        ),
      ),
    );
  }
}
