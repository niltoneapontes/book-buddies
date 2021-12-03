import 'package:bookbuddies/components/app-drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Olá, Nilton Pontes'),
        flexibleSpace: Image(
          image: AssetImage('assets/header.png'),
          fit: BoxFit.fill,
          alignment: Alignment.bottomCenter,
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Histórico',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Limpar',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              child: ListView.builder(
                itemCount: 8,
                padding: EdgeInsets.only(
                  bottom: 24,
                  left: 24,
                  right: 24,
                ),
                itemBuilder: (ctx, i) {
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Os Testamentos',
                          ),
                          Text(
                            'Margaret Atwood',
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text('Disponível - 2km'),
                          Text('Tairine Ellen')
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Flivrariaflorence.fbitsstatic.net%2Fimg%2Fp%2Flivro-os-testamentos-atwood-196714%2F383057.jpg%3Fw%3D660%26h%3D660%26v%3Dno-change&f=1&nofb=1'),
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
