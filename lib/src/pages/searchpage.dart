import 'package:flutter/material.dart';
import 'package:contactbook_app/src/pages/contact_model.dart';
class Search extends StatefulWidget {
  final List<ContactModel> recentContacts;

  const Search({Key? key, required this.recentContacts}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<ContactModel> contactList = [
    ContactModel(contactName: 'Leo', emailId: 'Leo123@gmail.com', mobile: 7959403231,),
    // Other contact models...
  ];

  late List<ContactModel> combinedContactList;
  late List<ContactModel> displayList;

  @override
  void initState() {
    super.initState();
    combinedContactList = List.from(contactList)..addAll(widget.recentContacts);
    displayList = List.from(combinedContactList);
  }

  void updateList(String value) {
    setState(() {
      displayList = combinedContactList.where((element) => element.contactName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb74093,),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0.0,
        title: Text('Search page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search for Contacts ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.white),
              onChanged: (value) => updateList(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Eg: Johns ',
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.purple.shade900,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: displayList.isEmpty
                  ? Center(
                child: Text(
                  'No result found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Text(
                    displayList[index].contactName!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${displayList[index].emailId!}',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Text(
                    '${displayList[index].mobile}',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
