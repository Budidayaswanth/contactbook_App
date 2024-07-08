import 'package:flutter/material.dart';

class Lock extends StatefulWidget {
  const Lock({Key? key}) : super(key: key);

  @override
  State<Lock> createState() => _LockState();
}

class _LockState extends State<Lock> {
  final TextEditingController _passwordController = TextEditingController();
  String _password = '';
  Map<String, dynamic> _data = {};

  @override
  Widget build(BuildContext context) {
    final args = _data.isNotEmpty ? _data : ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _data = args;
    }

    String bgImage = _data['isDayTime'] ? 'day.png' : 'night.png';
    Color? bgColor = _data['isDayTime'] ? Colors.blue : Colors.indigo[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child:  SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/$bgImage'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: Column(
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () async {
                      dynamic result = await Navigator.pushNamed(context, '/location');
                      setState(() {
                        _data = {
                          'time': result['time'],
                          'location': result['location'],
                          'flag': result['flag'],
                          'url': result['url'],
                          'isDayTime': result['isDayTime'],
                        };
                      });
                    },
                    icon: Icon(
                      Icons.edit_location,
                      color: Colors.grey,
                    ),
                    label: Text(
                      'Edit Location',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _data['location'],
                        style: TextStyle(
                          fontSize: 25.6,
                          letterSpacing: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    _data['time'],
                    style: TextStyle(
                      fontSize: 66.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Text('Welcome', style: TextStyle(fontSize: 24.0, color: Colors.white)),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        _password = val;
                      });
                    },
                  ),
                  SizedBox(height: 80.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _authenticate,
                      child: Text(
                        'Unlock',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _authenticate() {
    if (_password == '1234') {
      final Map<String, dynamic>? data = _data;
      if (data != null) {
        final String location = data['location'];
        Navigator.pushNamed(context, '/home', arguments: data);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect Password')),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
