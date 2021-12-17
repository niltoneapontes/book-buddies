import 'dart:math';

import 'package:bookbuddies/components/button.dart';
import 'package:bookbuddies/models/book.dart';
import 'package:bookbuddies/providers/location_provider.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookForm extends StatefulWidget {
  const BookForm({Key? key}) : super(key: key);

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();

  DatabaseReference reference = FirebaseDatabase.instance.ref();
  User? currentUser = FirebaseAuth.instance.currentUser;

  void _submitForm(location) {
    location.getLocation();

    _formKey.currentState?.save();
    final newBook = Book(
      id: Random().nextDouble().toString(),
      author: _formData['author'] as String,
      title: _formData['title'] as String,
      coverURL: _formData['coverURL'] as String,
      available: true,
      position:
          "{lat: ${location.userLocation.latitude}, long: ${location.userLocation.longitude}}",
      host: currentUser?.displayName ?? '',
      uid: currentUser?.uid ?? '',
      hostPhone: currentUser?.phoneNumber ?? '',
    );

    final newReference = reference.push();
    newReference.set({
      'id': newBook.id,
      'author': newBook.author,
      'title': newBook.title,
      'coverURL': newBook.coverURL,
      'available': newBook.available,
      'position': newBook.position,
      'host': newBook.host,
      'uid': newBook.uid,
      'hostPhone': newBook.hostPhone,
    });
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cadastre um livro'),
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
          padding: EdgeInsets.all(24),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'O nome do livro é necessário';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _formData['title'] = value ?? '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Título do livro',
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Autoria é necessária';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _formData['author'] = value ?? '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Autoria',
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'A URL da capa é necessária';
                    } else {
                      return null;
                    }
                  },
                  focusNode: _imageUrlFocus,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  onSaved: (imageUrl) => _formData['coverURL'] = imageUrl ?? '',
                  decoration: InputDecoration(
                    labelText: 'URL da Capa',
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        color: Color(0xFFC41212),
                      ),
                    ),
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
                        color: Color(0xff909A9E),
                      ),
                    ),
                    focusColor: Color(0xff909A9E),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  autocorrect: false,
                ),
                SizedBox(height: 12),
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(
                    top: 12,
                    left: 12,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? Text(
                          'Informe a URL',
                          textAlign: TextAlign.center,
                        )
                      : FittedBox(
                          fit: BoxFit.cover,
                          child: Image.network(_imageUrlController.text),
                        ),
                ),
                SizedBox(height: 24),
                CustomButton(
                    title: 'CADASTRAR',
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm(locationProvider);
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
