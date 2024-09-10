import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  String? _errorMessage;
  String? _emailErrorMessage;
  String? _nameErrorMessage;
  String? _phoneErrorMessage;
  String? _passwordErrorMessage;
  String? _confirmpasswordErrorMessage;

  bool _validateInputs() {
    setState(() {
      _nameErrorMessage = null;
      _emailErrorMessage = null;
      _phoneErrorMessage = null;
      _passwordErrorMessage = null;
      _confirmpasswordErrorMessage = null;
    });

    bool isValid = true;

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameErrorMessage = 'Please enter your name';
      });
      isValid = false;
    }
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailErrorMessage = 'Please enter your email';
      });
      isValid = false;
    } else if (!_emailController.text.contains('@')) {
      setState(() {
        _emailErrorMessage = 'Please enter a valid email address';
      });
      isValid = false;
    }

    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneErrorMessage = 'Please enter your phone';
      });
      isValid = false;
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordErrorMessage = 'Please enter your password';
      });
      isValid = false;
    }
    if (_confirmpasswordController.text.isEmpty) {
      setState(() {
        _confirmpasswordErrorMessage = 'Please enter password again';
      });
      isValid = false;
    }else if (_confirmpasswordController.text != _passwordController.text) {
      setState(() {
        _confirmpasswordErrorMessage = 'Password and Confirm password are not same';
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _nameErrorMessage,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailErrorMessage,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                errorText: _phoneErrorMessage,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordErrorMessage,
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmpasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: _confirmpasswordErrorMessage,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _errorMessage = null; // Reset error message
                });

                if (_validateInputs()) {
                  try {
                    var response = await Provider.of<AuthProvider>(context, listen: false).signup(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                      _confirmpasswordController.text,
                      _phoneController.text,
                    );
                    if (response['status'] == "success") {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      var message = response['message'];
                      String errorMessage = "";
                      if (message.containsKey('email')) {
                        _emailErrorMessage = message['email'];
                      }
                      if (message.containsKey('phone')) {
                        _phoneErrorMessage = message['phone'];
                      }
                      setState(() {
                        _errorMessage = errorMessage;
                      });
                    }
                  } catch (error) {
                    setState(() {
                      _errorMessage = error.toString();
                    });
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Signup Error'),
                        content: Text(error.toString()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: const Text('Signup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
