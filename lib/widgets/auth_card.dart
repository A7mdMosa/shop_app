import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/screens/products_screen.dart';
import '/login_shared_prefrences.dart';

enum AuthMode { signUp, logIn }

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.logIn;
  final _auth = FirebaseAuth.instance;
  final _passwordController = TextEditingController();

  String userName = '';
  String email = '';
  String password = '';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.logIn) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        await LoginSharedPrefrences.savePref(email, password);
        Navigator.pushReplacementNamed(context, ProductsScreen.route);
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await LoginSharedPrefrences.savePref(email, password);
        Navigator.pushReplacementNamed(context, ProductsScreen.route);
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2.0,
      child: Container(
        height: _authMode == AuthMode.signUp ? 450 : 300,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 450 : 300),
        width: deviceSize.width * 0.90,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 15),
                      label: const Text('E-Mail'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 15),
                      label: const Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (_authMode == AuthMode.logIn) {
                        if (value!.isEmpty) {
                          return 'inter the password!';
                        }
                      }
                      if (_authMode == AuthMode.signUp) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      }
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                ),
                if (_authMode == AuthMode.signUp)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signUp,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 15),
                        label: const Text('Confirm Password'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: _authMode == AuthMode.signUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                          : null,
                    ),
                  ),
                if (_authMode == AuthMode.signUp)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signUp,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 15),
                        label: const Text(
                          'Username',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Inter the Username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value!;
                      },
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        Text(_authMode == AuthMode.logIn ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                        )),
                  ),
                TextButton(
                  child: Text(
                    _authMode == AuthMode.logIn ? 'SignUp' : 'LogIn',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  onPressed: _switchAuthMode,
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
