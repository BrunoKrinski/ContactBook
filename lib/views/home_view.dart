import 'contact_view.dart';
import '../models/contact.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum OrderOptions { orderaz, orderza }

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Contact> contacts = [];
  Box database = Hive.box('contactBox');

  void populateDatabase() {
    print(database.length);
    if (database.length > 0) {
      for (var i = 0; i < database.length; i++) {
        Contact c = database.getAt(i);
        c.id = i;
        print(c.toString());
        contacts.add(c);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      populateDatabase();
    });
  }

  void showOptions(BuildContext context, int index) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      launchUrlString("tel: ${contacts[index].phone}");
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Call',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete ${contacts[index].name}?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    database.deleteAt(index);

                                    setState(() {
                                      contacts = [];
                                      populateDatabase();
                                    });
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  GestureDetector contactCart(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: contacts[index].image == null
                    ? AssetImage('assets/images/person.png') as ImageProvider
                    : MemoryImage(contacts[index].image!),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts Book'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderaz,
                child: Text("Order A-Z"),
              ),
              PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderza,
                child: Text("Order Z-A"),
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return contactCart(context, index);
        },
      ),
    );
  }

  void _orderList(OrderOptions result) {
    switch(result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        });
        break;
    }
    database.clear();
    for(var i = 0; i < contacts.length; i++){
      database.add(contacts[i]);
    }

    setState(() {

    });
  }

  void _showContactPage({Contact? contact}) async {
    Contact? editedContact;

    editedContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactView(
          contact: contact,
        ),
      ),
    );

    if (editedContact != null) {
      //print('editedC: ${editedContact.name}');
      if (editedContact.id != null) {
        //print('editedC id: ${editedContact.id}');
        database.putAt(editedContact.id!, editedContact);
        setState(() {
          contacts[editedContact!.id!] = editedContact;
        });
      } else {
        await database.add(editedContact);
        setState(() {
          contacts = [];
          populateDatabase();
        });
      }
    }
  }
}
