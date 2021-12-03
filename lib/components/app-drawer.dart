import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8,
      child: Column(
        children: [
          AppBar(
            title: Text('BookBuddies'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 12),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 32,
            ),
            title: Text('Perfil'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 32,
            ),
            title: Text('Configurações'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.info_rounded,
              size: 32,
            ),
            title: Text('Sobre o App'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
