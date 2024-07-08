import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contactbook_app/src/pages/searchpage.dart';
import 'package:contactbook_app/src/pages/contact_model.dart';

class ContactBook extends StatefulWidget {
  const ContactBook({Key? key, required this.loggedInUser}) : super(key: key);

  final String loggedInUser;

  @override
  State<ContactBook> createState() => _ContactBookState();
}

class _ContactBookState extends State<ContactBook> {
  late SharedPreferences _prefs;
  late List<ContactModel> userContacts = [];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadContacts();
  }

  void _loadContacts() {
    final String contactsKey = 'userContacts_${widget.loggedInUser}';
    final String? storedContacts = _prefs.getString(contactsKey);

    if (storedContacts != null) {
      setState(() {
        userContacts = contactListFromJson(storedContacts);
      });
    } else {
      setState(() {
        userContacts = [];
      });
    }
  }

  void _saveContacts() async {
    final String contactsKey = 'userContacts_${widget.loggedInUser}';
    final String encodedContacts = contactListToJson(userContacts);
    bool result = await _prefs.setString(contactsKey, encodedContacts);
    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save contacts')),
      );
    }
  }

  List<ContactModel> contactListFromJson(String jsonString) {
    final Iterable<dynamic> parsed = json.decode(jsonString);
    return parsed.map<ContactModel>((json) => ContactModel.fromJson(json)).toList();
  }

  String contactListToJson(List<ContactModel> list) {
    List<Map<String, dynamic>> jsonData = list.map((contact) => contact.toJson()).toList();
    return json.encode(jsonData);
  }

  void _addContact(ContactModel contact) {
    setState(() {
      userContacts.add(contact);
      _saveContacts();
    });
  }

  void _removeContact(int index) {
    setState(() {
      userContacts.removeAt(index);
      _saveContacts();
    });
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search(recentContacts: userContacts)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.loggedInUser}'),
        backgroundColor: Colors.grey[200],
        actions: [
          IconButton(onPressed: _navigateToSearch, icon: Icon(Icons.search)),
          SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://wallpaper.forfun.com/fetch/d4/d4bb53aec57075525fa753d6a1c383b4.jpeg?h=900&r=0.5'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: _showAddContactDialog,
                    icon: Icon(Icons.add),
                    label: Text('Add Contact'),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight - 100,
                  child: ListView.builder(
                    itemCount: userContacts.length,
                    itemBuilder: (context, index) {
                      final contact = userContacts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(contact.contactName ?? ''),
                          subtitle: Text(contact.emailId ?? ''),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeContact(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    String name = '';
    String email = '';
    String mobile = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Mobile'),
                onChanged: (value) {
                  mobile = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (mobile.isNotEmpty && int.tryParse(mobile) != null) {
                  _addContact(ContactModel(contactName: name, emailId: email, mobile: int.parse(mobile)));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mobile number is invalid')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
