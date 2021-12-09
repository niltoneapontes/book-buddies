import 'package:bookbuddies/components/app-drawer.dart';
import 'package:bookbuddies/components/map.dart';
import 'package:bookbuddies/models/book.dart';
import 'package:bookbuddies/models/userLocation.dart';
import 'package:bookbuddies/providers/location_provider.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:bookbuddies/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _shouldShowMap = false;
  String _searchValue = '';

  List<Book> books = [
    Book(
      id: '1',
      title: 'Os Testamentos',
      coverURL:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Flivrariaflorence.fbitsstatic.net%2Fimg%2Fp%2Flivro-os-testamentos-atwood-196714%2F383057.jpg%3Fw%3D660%26h%3D660%26v%3Dno-change&f=1&nofb=1',
      author: 'Margaret Atwood',
      host: 'Tairine Ellen',
      available: true,
      distance: '2km',
      hostPhone: '(81)90000-0000',
    ),
    Book(
      id: '2',
      title: 'Harry Potter e a Pedra Filosofal',
      coverURL:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ffccmansfield.org%2Fimg%2Fread-harry-potter-book-1-3.jpg&f=1&nofb=1',
      author: 'J. K. Rowling',
      host: 'Tairine Ellen',
      available: true,
      distance: '5km',
      hostPhone: '(81)90000-0000',
    ),
    Book(
      id: '3',
      title: 'Os Testamentos',
      coverURL:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Flivrariaflorence.fbitsstatic.net%2Fimg%2Fp%2Flivro-os-testamentos-atwood-196714%2F383057.jpg%3Fw%3D660%26h%3D660%26v%3Dno-change&f=1&nofb=1',
      author: 'Margaret Atwood',
      host: 'Nilton Pontes',
      available: false,
      distance: '10km',
      hostPhone: '(81)90000-0000',
    ),
    Book(
      id: '4',
      title: 'Harry Potter e a Pedra Filosofal',
      coverURL:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ffccmansfield.org%2Fimg%2Fread-harry-potter-book-1-3.jpg&f=1&nofb=1',
      author: 'J. K. Rowling',
      host: 'Nilton Pontes',
      available: true,
      distance: '1km',
      hostPhone: '(81)90000-0000',
    ),
  ];

  @override
  void dispose() {
    LocationServices().closeLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor.withOpacity(0),
        statusBarBrightness: Brightness.light,
      ),
    );

    User currentUser = FirebaseAuth.instance.currentUser as User;
    var locationProvider = Provider.of<LocationProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Olá, ${currentUser.displayName}'),
          flexibleSpace: Image(
            image: AssetImage('assets/header.png'),
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
          ),
        ),
        drawer: AppDrawer(),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            children: [
              Container(
                height: _shouldShowMap == false
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  top: _shouldShowMap == false
                      ? MediaQuery.of(context).size.height * 0.25
                      : MediaQuery.of(context).size.height * 0.15 - 8,
                ),
                width: double.infinity,
                child: (_shouldShowMap == false && books.length > 0)
                    ? ListView.builder(
                        itemCount: books.length,
                        padding: EdgeInsets.only(
                          bottom: 24,
                          left: 24,
                          right: 24,
                        ),
                        itemBuilder: (ctx, i) {
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 12),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    AppRoutes.BOOK_DETAILS,
                                    arguments: books[i]);
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    books[i].title,
                                  ),
                                  Text(
                                    books[i].author,
                                  )
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(books[i].available
                                      ? 'Disponível - ${books[i].distance}'
                                      : 'Indisponível - ${books[i].distance}'),
                                  Text(books[i].host)
                                ],
                              ),
                              leading: CircleAvatar(
                                radius: 32,
                                backgroundImage:
                                    NetworkImage(books[i].coverURL),
                              ),
                              contentPadding: EdgeInsets.all(12),
                            ),
                          );
                        },
                      )
                    : (_shouldShowMap == false && books.length == 0)
                        ? Padding(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inbox,
                                  size: 120,
                                  color: Colors.grey,
                                ),
                                Text('Você não pesquisou por nada ainda :(',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          )
                        : Center(
                            child: _searchValue.contains('Harry')
                                ? StreamProvider<UserLocation>(
                                    initialData: locationProvider.userLocation,
                                    create: (context) =>
                                        LocationServices().locationStream,
                                    child: MapWidget(),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(40),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 120,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                            'Não conseguimos encontrar esse livro :(',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ],
                                    ),
                                  ),
                          ),
              ),
              Card(
                elevation: 3,
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 24, right: 24, left: 24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  height: _shouldShowMap == false
                      ? MediaQuery.of(context).size.height * 0.25
                      : MediaQuery.of(context).size.height * 0.15,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {
                          locationProvider.getLocation();
                          setState(() {
                            _shouldShowMap = true;
                            _searchValue = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Pesquise por um livro',
                          prefixIcon: Icon(Icons.search),
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
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(0),
                        ),
                      ),
                      _shouldShowMap == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Histórico',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      books = [];
                                    });
                                  },
                                  child: Text('Limpar',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: SizedBox(
                                height: 0,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _shouldShowMap == false
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.BOOK_FORM);
                },
              )
            : null);
  }
}
