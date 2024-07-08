import 'package:flutter/material.dart';
import 'package:contactbook_app/src/pages/home.dart';
import 'package:contactbook_app/src/pages/register.dart';
import 'package:contactbook_app/src/pages/contactbook.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/home': (context) => const Home(),
        '/register': (context) => Register(users: {}),
        '/contact': (context) => ContactBook(loggedInUser: ''),
      },
    );
  }
}
