import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sir_syed_case/data.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sir_syed_case/firebase_auth_services.dart';
import 'package:sir_syed_case/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

Student newStudent = Student('', '', '', '', '', '', '', '', '', '', '', '');

class SignUpPageState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isButtonEnabled = true;
  bool _isEmailValid = false;
  bool _doPasswordsMatch = false;
  bool emailInteraction = false;
  bool confirmPasswordInteraction = false;
  bool hasError = false;
  String? selectedGender;
  String? selectedBatch;
  String? selectedDegree;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();

  bool firebaseState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 48, 85),
        foregroundColor: Colors.white,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/case-logo.png',
                width: 150,
                height: 150,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _firstNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _lastNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          Text('Male'),
                          Radio(
                            value: 'Female',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _fatherNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Father\'s Name',
                      errorText: hasError ? 'Invalid input' : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        hasError = !RegExp(r'^[a-zA-Z\s]*$').hasMatch(value);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _cnicController,
                        keyboardType: TextInputType.number,
                        maxLength: 15, // 13 digits + 2 dashes
                        decoration: InputDecoration(
                          labelText: 'CNIC',
                          hintText: 'XXXXX-XXXXXXX-X',
                        ),
                        onChanged: (value) {
                          if ((value.length == 5 || value.length == 13) &&
                              !_cnicController.text.endsWith('-')) {
                            _cnicController.text += '-';
                            _cnicController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: _cnicController.text.length),
                            );
                          } else if (value.length == 5 &&
                              _cnicController.text.endsWith('-')) {
                            _cnicController.text = value.substring(0, 4);
                            _cnicController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: _cnicController.text.length),
                            );
                          } else if (value.length == 13 &&
                              _cnicController.text.endsWith('-')) {
                            _cnicController.text = value.substring(0, 13);
                            _cnicController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: _cnicController.text.length),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _rollNoController,
                        keyboardType: TextInputType.number,
                        maxLength: 9, // 8 digits + 1 dashes
                        decoration: InputDecoration(
                          labelText: 'Roll Number',
                          hintText: 'XXXX-XXXX',
                        ),
                        onChanged: (value) {
                          if (value.length == 4 &&
                              !_rollNoController.text.endsWith('-')) {
                            _rollNoController.text += '-';
                            _rollNoController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _rollNoController.text.length),
                            );
                          } else if (value.length == 4 &&
                              _rollNoController.text.endsWith('-')) {
                            _rollNoController.text = value.substring(0, 4);
                            _rollNoController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _rollNoController.text.length),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedBatch,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBatch = newValue!;
                          });
                        },
                        items: <String>[
                          'Sp-2024',
                          'Fa-2023',
                          'Su-2023',
                          'Sp-2023',
                          'Fa-2022',
                          'Su-2022',
                          'Sp-2022',
                          'Fa-2021',
                          'Su-2021',
                          'Sp-2021',
                          'Fa-2020',
                          'Su-2020',
                          'Sp-2020',
                          'Fa-2019',
                          'Su-2019',
                          'Sp-2019',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Batch',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedDegree,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDegree = newValue!;
                          });
                        },
                        items: <String>[
                          'B.B.A',
                          'B.Com',
                          'BSAF',
                          'BSAI',
                          'BSCS',
                          'BSEE',
                          'BSSE',
                          'MS Mathematics',
                          'MSCS',
                          'MSEE',
                          'MSEM',
                          'Ph.D. EE',
                          'Ph.D. EM',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Degree',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: !emailInteraction || _isEmailValid
                          ? null
                          : 'Invalid Email',
                    ),
                    onChanged: (_) {
                      setState(() {
                        emailInteraction = true;
                        _isEmailValid = _validateEmail();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                  child: TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.all(16.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText:
                          !confirmPasswordInteraction || _doPasswordsMatch
                              ? null
                              : 'Passwords Don\'t Match',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                    onChanged: (_) {
                      setState(() {
                        confirmPasswordInteraction = true;
                        _doPasswordsMatch = (_passwordController.text ==
                            _confirmPasswordController.text);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 156, 132, 58),
                    ),
                  ),
                  //onPressed: _handleSignUp,
                  onPressed: isButtonEnabled
                      ? () {
                          newStudent.firstName = _firstNameController.text;
                          newStudent.lastName = _lastNameController.text;
                          newStudent.fatherName = _fatherNameController.text;
                          newStudent.cnic = _cnicController.text;
                          newStudent.phone = _phoneController.text;
                          newStudent.gender = selectedGender ?? '';
                          newStudent.rollNo = _rollNoController.text;
                          newStudent.batch = selectedBatch ?? '';
                          newStudent.degree = selectedDegree ?? '';
                          newStudent.email = _emailController.text;
                          newStudent.password = _passwordController.text;
                          newStudent.confirmPassword =
                              _confirmPasswordController.text;

                          validateSignup();
                        }
                      : null,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void validateSignup() {
    bool isValidEmail = EmailValidator.validate(_emailController.text);

    if (newStudent.firstName.isEmpty ||
        newStudent.lastName.isEmpty ||
        newStudent.gender.isEmpty ||
        newStudent.fatherName.isEmpty ||
        newStudent.cnic.isEmpty ||
        newStudent.phone.isEmpty ||
        newStudent.rollNo.isEmpty ||
        newStudent.batch.isEmpty ||
        newStudent.degree.isEmpty ||
        newStudent.email.isEmpty ||
        newStudent.password.isEmpty ||
        newStudent.confirmPassword.isEmpty) {
      showErrorDialog("Input Fields Empty");
    } else if (!isValidEmail) {
      showErrorDialog('Invalid Email Format');
      return;
    } else if (newStudent.password != newStudent.confirmPassword) {
      showErrorDialog("Passwords Don't Match");
      clearFields();
    } else {
      FirebaseSignUp();
    }
  }

  void showErrorDialog(String message) {
    isButtonEnabled = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Error",
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
                  Navigator.of(context).pop();
                  isButtonEnabled = true;
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

  bool _validateEmail() {
    String email = _emailController.text.trim();
    if (email.isEmpty || !EmailValidator.validate(email)) {
      return false;
    }
    return true;
  }

  void showSuccessDialog(String message) {
    isButtonEnabled = false;

    // currentStudent.firstName = _firstNameController.text;
    // currentStudent.lastName = _lastNameController.text;
    // currentStudent.fatherName = _fatherNameController.text;
    // currentStudent.cnic = _cnicController.text;
    // currentStudent.phone = _phoneController.text;
    // currentStudent.gender = selectedGender!;
    // currentStudent.rollNo = _rollNoController.text;
    // currentStudent.batch = selectedBatch!;
    // currentStudent.degree = selectedDegree!;
    // currentStudent.email = _emailController.text;
    // currentStudent.password = _passwordController.text;
    // currentStudent.confirmPassword = _confirmPasswordController.text;

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
                      builder: (context) => LoginScreen(),
                    ),
                  );
                  //Navigator.of(context).pop();
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
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fatherNameController.dispose();
    _rollNoController.dispose();
    _emailFocus.dispose();

    super.dispose();
  }

  Future<void> FirebaseSignUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? newUser = await _auth.signupWithEmailAndPassword(email, password);

    if (newUser != null) {
      FirebaseSendData();
      firebaseState = true;
      showSuccessDialog('Sign Up Successful!!!');
    } else {
      print("Error Occured");
      firebaseState = false;
    }
  }

  Future FirebaseSendData() async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('Users').doc('${newStudent.email}').set({
      'firstName': '${newStudent.firstName}',
      'lastName': '${newStudent.lastName}',
      'gender': '${newStudent.gender}',
      'fatherName': '${newStudent.fatherName}',
      'cnic': '${newStudent.cnic}',
      'phone': '${newStudent.phone}',
      'rollNo': '${newStudent.rollNo}',
      'batch': '${newStudent.batch}',
      'degree': '${newStudent.degree}',
      'email': '${newStudent.email}',
      'password': '${newStudent.password}',
      'confirmPassword': '${newStudent.confirmPassword}',
    });
  }
}
