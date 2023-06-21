import 'models/contact.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:contact_book/views/home_view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());
  await Hive.openBox('contactBox');
  runApp(ContactBook());
}

class ContactBook extends StatelessWidget {
  const ContactBook({super.key});

  @override
  Widget build(BuildContext context) {
    //testDB();

    return MaterialApp(
      title: "Contact Book",
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
