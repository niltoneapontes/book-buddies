import 'package:bookbuddies/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3,
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
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.PROFILE);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 32,
            ),
            title: Text('Configurações'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.SETTINGS);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_rounded,
              size: 32,
            ),
            title: Text('Sobre o App'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.ABOUT);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 32,
            ),
            title: Text('Sair'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('@bb_user');
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
            },
          ),
        ],
      ),
    );
  }
}
