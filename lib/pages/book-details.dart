import 'package:bookbuddies/components/button.dart';
import 'package:bookbuddies/components/primary-button.dart';
import 'package:bookbuddies/components/secondary-button.dart';
import 'package:bookbuddies/models/book.dart';
import 'package:flutter/material.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Book book = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detalhes do Livro'),
        flexibleSpace: Image(
          image: AssetImage('assets/header.png'),
          fit: BoxFit.fill,
          alignment: Alignment.bottomCenter,
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: Image.network(book.coverURL),
                ),
              );
            },
            child: Container(
              child: Image.network(
                book.coverURL,
                fit: BoxFit.cover,
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      book.author,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.available ? 'Disponível' : 'Indisponível',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: book.available ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(
                      book.host,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'Há ${book.distance} de você',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                CustomButton(
                    title: 'CONTATO',
                    onPress: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => Dialog(
                            child: Container(
                          alignment: Alignment.center,
                          height: 160,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                book.host,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                book.hostPhone,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                ),
                              ),
                              SecondaryButton(
                                  title: 'FECHAR',
                                  onPress: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          ),
                        )),
                      );
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
