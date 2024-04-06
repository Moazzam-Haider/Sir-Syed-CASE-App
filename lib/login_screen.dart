import 'package:flutter/material.dart';
import 'package:sir_syed_case/data.dart';
import 'package:sir_syed_case/dashboard.dart';
import 'package:sir_syed_case/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sir_syed_case/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool firebaseState = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text(
              'Login Screen',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 20, 48, 85),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Image.asset(
                'assets/case-logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 40),
              // User ID input field
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    //border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    //border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // Toggle password visibility
                        _togglePasswordVisibility();
                      },
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 156, 132, 58),
                  ),
                ),
                onPressed: () {
                  validateLogin();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              // Sign Up link
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Signup',
                        style: TextStyle(color: Colors.blue),
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

  void _togglePasswordVisibility() {
    // Toggle the obscureText property of the password field
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void validateLogin() {
    String enteredEmail = _emailController.text;
    String enteredPassword = _passwordController.text;

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      showErrorDialog("Input Fields Empty");
    } else {
      FirebaseSignIn();
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Error",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Text(message)),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 156, 132, 58)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Success",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Text(message)),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 20, 48, 85)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void clearFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  void FirebaseSignIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? newUser = await _auth.signinWithEmailAndPassword(email, password);

    if (newUser != null) {
      FirebaseRetrieveData();
      firebaseState = true;
      showSuccessDialog('Login Sucessful');
    } else {
      print("Error Occured");
      firebaseState = false;
    }
  }

  Future<void> FirebaseRetrieveData() async {
    try {
      final firestore = FirebaseFirestore.instance;
      String email = _emailController.text;

      QuerySnapshot querySnapshot = await firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Data is found, you can access it using querySnapshot.docs
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          // Access fields using doc['fieldName']
          currentStudent.firstName = doc['firstName'];
          currentStudent.lastName = doc['lastName'];
          currentStudent.gender = doc['gender'];
          currentStudent.fatherName = doc['fatherName'];
          currentStudent.cnic = doc['cnic'];
          currentStudent.rollNo = doc['rollNo'];
          currentStudent.phone = doc['phone'];
          currentStudent.batch = doc['batch'];
          currentStudent.degree = doc['degree'];
          currentStudent.email = doc['email'];
          currentStudent.password = doc['password'];
          currentStudent.confirmPassword = doc['confirmPassword'];
        }
      } else {
        // No matching data found
        print('User not found');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }
}
