import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final Function onPress;

  const SecondaryButton({Key? key, required this.title, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          onPress();
        },
      ),
    );
  }
}
