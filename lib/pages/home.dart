import 'dart:collection';
import 'dart:convert';
import 'dart:math';

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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _shouldShowMap = false;
  String _searchValue = '';

  DatabaseReference reference = FirebaseDatabase.instance.ref();

  List<Book> history = [];

  List<Book> books = [];
  List<Circle> circles = [];
  List<Marker> markers = [];

  @override
  void dispose() {
    LocationServices().closeLocation();
    super.dispose();
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  double getDistance(lat1, long1, lat2, long2) {
    const R = 6371;
    final dLat = deg2rad(lat2 - lat1);
    final dLon = deg2rad(long2 - long1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final d = R * c;
    return d;
  }

  LatLng parsePosition(String position) {
    final lat = double.tryParse(position.split(',')[0].split(':')[1]);
    final long = double.tryParse(
        position.split(',')[1].split(':')[1].replaceAll('}', ''));
    return LatLng(lat ?? 0, long ?? 0);
  }

  void clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('@bb_history');

    setState(() {
      history = [];
    });
  }

  void loadBooks(locationProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final jsonLoadedHistory = prefs.getString('@bb_history') ?? '[]';

    final loadedHistory = json.decode(jsonLoadedHistory);

    print('loaded: $loadedHistory');

    DatabaseEvent event = await reference.once();

    if (event.snapshot.value != null && _searchValue != '') {
      final loadedData = HashMap.from(event.snapshot.value as dynamic);
      final List<Book> loadedBooks = [];
      final List<Circle> loadedCircles = [];
      final List<Marker> loadedMarkers = [];

      loadedData.forEach((key, book) {
        Map<String, Object> loadedBook = {};
        // print('key: $key, book: $book');
        book.forEach((k, b) {
          loadedBook[k] = b;
        });

        final bookTitle = loadedBook['title'] as String;

        if (bookTitle.toLowerCase().contains(_searchValue.toLowerCase())) {
          loadedBooks.add(Book(
            id: loadedBook['id'] as String,
            author: loadedBook['author'] as String,
            title: loadedBook['title'] as String,
            available: loadedBook['available'] as bool,
            coverURL: loadedBook['coverURL'] as String,
            position: loadedBook['position'] as String,
            host: loadedBook['host'] as String,
            uid: loadedBook['uid'] as String,
            hostPhone: loadedBook['hostPhone'] as String,
          ));
          loadedCircles.add(
            new Circle(
              zIndex: 5,
              circleId: CircleId(loadedBook['title'] as String),
              center: parsePosition(loadedBook['position'].toString()),
              visible: true,
              fillColor: Color.fromRGBO(0, 166, 166, 0.2),
              radius: 16,
              strokeColor: Color.fromRGBO(0, 166, 166, 1),
              strokeWidth: 1,
            ),
          );
          final parsedPosition =
              parsePosition(loadedBook['position'].toString());
          final distance = getDistance(
            locationProvider.userLocation.latitude,
            locationProvider.userLocation.longitude,
            parsedPosition.latitude,
            parsedPosition.longitude,
          );

          loadedMarkers.add(
            new Marker(
              markerId: MarkerId(loadedBook['title'] as String),
              position: parsedPosition,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
              alpha: 1,
              zIndex: 7,
              infoWindow: InfoWindow(
                  title: loadedBook['title'] as String,
                  snippet:
                      '${loadedBook['author']} - ${distance.toStringAsFixed(1)}km com ${loadedBook['host']}',
                  onTap: () async {
                    await prefs.setString(
                        '@bb_history',
                        json.encode([
                          ...history,
                          {
                            "id": loadedBook['id'] as String,
                            "author": loadedBook['author'] as String,
                            "title": loadedBook['title'] as String,
                            "available": loadedBook['available'] as bool,
                            "coverURL": loadedBook['coverURL'] as String,
                            "position": loadedBook['position'] as String,
                            "host": loadedBook['host'] as String,
                            "uid": loadedBook['uid'] as String,
                            "hostPhone": loadedBook['hostPhone'] as String,
                          }
                        ]));
                    Navigator.of(context).pushNamed(AppRoutes.BOOK_DETAILS,
                        arguments: Book(
                          id: loadedBook['id'] as String,
                          author: loadedBook['author'] as String,
                          title: loadedBook['title'] as String,
                          available: loadedBook['available'] as bool,
                          coverURL: loadedBook['coverURL'] as String,
                          position: loadedBook['position'] as String,
                          host: loadedBook['host'] as String,
                          uid: loadedBook['uid'] as String,
                          hostPhone: loadedBook['hostPhone'] as String,
                        ));
                  }),
            ),
          );
        }
      });
      setState(() {
        books = loadedBooks;
        circles = loadedCircles;
        markers = loadedMarkers;
      });
    } else {
      setState(() {
        books = [];
      });
    }

    final readyHistory = loadedHistory.map((element) {
      return Book(
        id: element['id'],
        title: element['title'],
        author: element['author'],
        coverURL: element['coverURL'],
        host: element['host'],
        hostPhone: element['hostPhone'],
        available: element['available'],
        position: element['position'],
        uid: element['uid'],
      );
    });

    setState(() {
      history = List<Book>.from(readyHistory);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor.withOpacity(0),
        statusBarBrightness: Brightness.light,
      ),
    );

    User? currentUser = FirebaseAuth.instance.currentUser;
    var locationProvider = Provider.of<LocationProvider>(context, listen: true);

    loadBooks(locationProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Olá, ${currentUser?.displayName}'),
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
                child: (_shouldShowMap == false && history.length > 0)
                    ? ListView.builder(
                        itemCount: history.length,
                        padding: EdgeInsets.only(
                          bottom: 24,
                          left: 24,
                          right: 24,
                        ),
                        itemBuilder: (ctx, i) {
                          final parsedPosition =
                              parsePosition(history[i].position.toString());
                          final distance = getDistance(
                            locationProvider.userLocation.latitude,
                            locationProvider.userLocation.longitude,
                            parsedPosition.latitude,
                            parsedPosition.longitude,
                          );

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
                                    arguments: history[i]);
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history[i].title,
                                  ),
                                  Text(
                                    history[i].author,
                                  )
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(history[i].available
                                      ? 'Disponível - ${distance.toStringAsFixed(1)}km'
                                      : 'Indisponível - ${distance.toStringAsFixed(1)}km'),
                                  Text(history[i].host)
                                ],
                              ),
                              leading: CircleAvatar(
                                radius: 32,
                                backgroundImage:
                                    NetworkImage(history[i].coverURL),
                              ),
                              contentPadding: EdgeInsets.all(12),
                            ),
                          );
                        },
                      )
                    : (_shouldShowMap == false && history.length == 0)
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
                            child: books.isNotEmpty
                                ? StreamProvider<UserLocation>(
                                    initialData: locationProvider.userLocation,
                                    create: (context) =>
                                        LocationServices().locationStream,
                                    child: MapWidget(
                                      circles: circles,
                                      markers: markers,
                                    ),
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
                                    clearHistory();
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
