import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/providers/location_provider.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isPasswordShown = false;
  bool isConfirmPasswordShown = false;

  RangeValues _currentRangeValues = const RangeValues(0, 5);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LocationProvider provider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Configurações'),
        flexibleSpace: Image(
          image: AssetImage('assets/header.png'),
          fit: BoxFit.fill,
          alignment: Alignment.bottomCenter,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height - 88,
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Raio Mínimo: ${_currentRangeValues.start.toStringAsFixed(0)}km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Raio Máximo: ${_currentRangeValues.end.toStringAsFixed(0)}km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        RangeSlider(
                          values: _currentRangeValues,
                          activeColor: Theme.of(context).accentColor,
                          inactiveColor: Colors.grey[300],
                          min: 0,
                          max: 50,
                          divisions: 50,
                          labels: RangeLabels(
                            _currentRangeValues.start.round().toString(),
                            _currentRangeValues.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRangeValues = values;
                              provider.setRange = [values.start, values.end];
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    title: 'SALVAR',
                    onPress: () {
                      Navigator.of(context).pushNamed(AppRoutes.LOGIN);
                    },
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
