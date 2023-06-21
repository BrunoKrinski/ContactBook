import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

part "contact.g.dart";

@HiveType(typeId: 1)
class Contact {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  Uint8List? image;

  Contact();

  Contact.fromMap(Map map){
    id = map["id"];
    name = map["name"];
    email = map["email"];
    phone = map["phone"];
    image = map["image"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "phone": phone,
      "image": image,
    };
    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(ID: $id, Name: $name, E-mail: $email, Phone: $phone, Image: $image)";
  }
}