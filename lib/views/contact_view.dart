import '../models/contact.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ContactView extends StatefulWidget {
  ContactView({super.key, this.contact});

  Contact? contact;

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  Contact? _editedContact;
  bool _userEdited = false;
  Box database = Hive.box('contactBox');

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      if (_editedContact!.name != null) {
        _nameController.text = _editedContact!.name!;
      }

      if (_editedContact!.email != null) {
        _emailController.text = _editedContact!.email!;
      }

      if (_editedContact!.phone != null) {
        _phoneController.text = _editedContact!.phone!;
      }
    }
  }

  Future<bool> _requestPop(BuildContext context) {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("discard changes?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Yes",
                style: TextStyle(color: Colors.red,),),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _getImage() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    //String image = mediaData!.data.toString();
    setState(() {
      _editedContact!.image = mediaData!.data;
    });
    //print(_editedContact!.image);
    //String mimeType = lookupMimeType(mediaData.relativePath!)!;
    //print(mimeType);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return _requestPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact?.name ?? "New Contact"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact!.name != null &&
                _editedContact!.name!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
          child: Icon(
            Icons.save,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _getImage();
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: _editedContact!.image == null ?
                  AssetImage('assets/images/person.png') as ImageProvider : MemoryImage(_editedContact!.image!),
                ),
              ),
              TextField(
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                    color: Colors.red,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                cursorColor: Colors.red,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact!.name = text;
                  });
                },
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.red,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                cursorColor: Colors.red,
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact!.email = text;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Phone",
                  labelStyle: TextStyle(
                    color: Colors.red,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                cursorColor: Colors.red,
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact!.phone = text;
                },
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}