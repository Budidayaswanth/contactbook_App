import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contactbook_app/src/pages/contactbook.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences _prefs;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static Map<String, String> users = {};

  bool _loggedIn = false;
  late String loggedInUser;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedIn = _prefs.getBool('loggedIn') ?? false;
      loggedInUser = _prefs.getString('loggedInUser') ?? '';
    });
  }

  void _navigateToContactPage() {
    Navigator.pushNamed(context, '/contact');
  }

  Future<void> _login() async {
    final user = _usernameController.text;
    final password = _passwordController.text;

    if (users.containsKey(user) && users[user] == password) {
      await _prefs.setBool('loggedIn', true);
      await _prefs.setString('loggedInUser', user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ContactBook(loggedInUser: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Book Application'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffE5B2CA), Color(0xffCD8258D)],
          ),
        ),
        child: Center(
          child: _loggedIn
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24.8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _navigateToContactPage,
                child: const Text('Go to Contact Page'),
              ),
            ],
          )
              : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.016),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to Contact Book',
                    style: TextStyle(
                      fontSize: 24.8,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.white),

                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your Username',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter your Username'
                                : null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter your Password'
                                : null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: _login,
                              child: const Text('Login'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/register');
                              },
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                      ],
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
