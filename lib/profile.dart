import 'package:flutter/material.dart';
import 'package:sir_syed_case/dashboard.dart';
import 'package:sir_syed_case/course.dart';
import 'package:sir_syed_case/login_screen.dart';
import 'package:sir_syed_case/schedule.dart';
import 'package:sir_syed_case/data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3;
  bool isLoading = false;

  Future<void> reloadProfilePage() async {
    // Show loading animation
    // setState(() {
    //   isLoading = true;
    // });

    // // Simulate some async operation, e.g., fetching data from an API
    // await Future.delayed(Duration(seconds: 2));

    // // Update data and hide loading animation
    // setState(() {
    //   isLoading = false;
    // });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  // Navigate to the login screen or another screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                } catch (e) {
                  print('Error logging out: $e');
                }

                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Profile Page',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 20, 48, 85),
          foregroundColor: Colors.white,
          actions: [
            // Add the logout button here
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: ProfileForm(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SchedulePage(),
                ),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CoursePage(),
                ),
              );
            } else if (index == 3) {
              reloadProfilePage();
            }
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 20, 45, 85),
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 20, 45, 85),
              icon: Icon(
                Icons.schedule,
              ),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 20, 45, 85),
              icon: Icon(
                Icons.library_books,
              ),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 20, 45, 85),
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            ),
          ],
          unselectedIconTheme: IconThemeData(color: Colors.white),
          selectedItemColor: const Color.fromARGB(255, 156, 132, 58),
          selectedIconTheme:
              IconThemeData(color: const Color.fromARGB(255, 156, 132, 58)),
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  // Define controllers for text input fields
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController fatherNameController;
  late TextEditingController cnicController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController batchController;
  late TextEditingController rollNumberController;
  late TextEditingController emailController;
  late TextEditingController degreeController;

  bool isEditing = false;
  bool _isPasswordVisible = false;

  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: currentStudent.firstName);
    lastNameController = TextEditingController(text: currentStudent.lastName);
    fatherNameController =
        TextEditingController(text: currentStudent.fatherName);
    cnicController = TextEditingController(text: currentStudent.cnic);
    phoneController = TextEditingController(text: currentStudent.phone);
    rollNumberController = TextEditingController(text: currentStudent.rollNo);
    degreeController = TextEditingController(text: currentStudent.degree);
    batchController = TextEditingController(text: currentStudent.batch);
    genderController = TextEditingController(text: currentStudent.gender);
    emailController = TextEditingController(text: currentStudent.email);
    passwordController = TextEditingController(text: currentStudent.password);
    confirmPasswordController =
        TextEditingController(text: currentStudent.confirmPassword);
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _cancelChanges() {
    setState(() {
      currentStudent.firstName = currentStudent.firstName;
      currentStudent.lastName = currentStudent.lastName;
      currentStudent.fatherName = currentStudent.fatherName;
      currentStudent.gender = currentStudent.gender;
      currentStudent.cnic = currentStudent.cnic;
      currentStudent.phone = currentStudent.phone;
      currentStudent.rollNo = currentStudent.rollNo;
      currentStudent.batch = currentStudent.batch;
      currentStudent.degree = currentStudent.degree;
      currentStudent.email = currentStudent.email;
      currentStudent.password = currentStudent.password;
      currentStudent.confirmPassword = currentStudent.confirmPassword;

      isEditing = false;
    });
  }

  Future<void> FirebaseUpdateData() async {
    try {
      final firestore = FirebaseFirestore.instance;
      String email = currentStudent.email;

      // Get reference to the document based on the email
      DocumentReference userRef = firestore.collection('Users').doc(email);

      // Assuming 'firstName' is the field you want to update

      // Update the data
      await userRef.update({
        'firstName': '${currentStudent.firstName}',
        'lastName': '${currentStudent.lastName}',
        'gender': '${currentStudent.gender}',
        'fatherName': '${currentStudent.fatherName}',
        'cnic': '${currentStudent.cnic}',
        'phone': '${currentStudent.phone}',
        'rollNo': '${currentStudent.rollNo}',
        'batch': '${currentStudent.batch}',
        'degree': '${currentStudent.degree}',
        'email': '${currentStudent.email}',
        'password': '${currentStudent.password}',
        'confirmPassword': '${currentStudent.confirmPassword}',
        // You can add more fields to update if needed
      });

      print('User data updated successfully');
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  void _saveChanges() {
    setState(() {
      currentStudent.firstName = firstNameController.text;
      currentStudent.lastName = lastNameController.text;
      currentStudent.fatherName = fatherNameController.text;
      currentStudent.gender = genderController.text;
      currentStudent.cnic = cnicController.text;
      currentStudent.phone = phoneController.text;
      currentStudent.rollNo = rollNumberController.text;
      currentStudent.batch = batchController.text;
      currentStudent.degree = degreeController.text;
      currentStudent.email = emailController.text;
      currentStudent.password = passwordController.text;
      currentStudent.confirmPassword = confirmPasswordController.text;

      isEditing = false;
    });
    FirebaseUpdateData();
    showSuccessDialog('Changes Saved!!!');
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
                    backgroundColor: Color.fromARGB(255, 20, 45, 85)),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      currentStudent.profileImage == null
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/profile image.png'),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  FileImage(currentStudent.profileImage!),
                            ),
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 40.0,
                        height: 40.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 156, 132, 58),
                        ),
                        child: InkWell(
                          onTap: _pickProfileImage,
                          borderRadius: BorderRadius.circular(20.0),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              _buildEditableField(
                  controller: firstNameController, label: 'First Name'),
              _buildEditableField(
                  controller: lastNameController, label: 'Last Name'),
              _buildEditableField(
                  controller: genderController, label: 'Gender'),
              _buildEditableField(
                  controller: fatherNameController, label: 'Father Name'),
              _buildEditableField(controller: cnicController, label: 'CNIC'),
              _buildEditableField(controller: phoneController, label: 'Phone'),
              _buildEditableField(
                  controller: rollNumberController, label: 'Roll Number'),
              _buildEditableField(controller: batchController, label: 'Batch'),
              _buildEditableField(
                  controller: degreeController, label: 'Degree'),
              _buildEditableField(controller: emailController, label: 'Email'),
              _buildEditablePasswordField(
                  controller: passwordController,
                  label: 'Password',
                  isVisible: _isPasswordVisible),
              _buildEditablePasswordField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  isVisible: _isPasswordVisible),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 156, 132, 58),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(
                        //     40.0,
                        //   ),
                        // ),
                      ),
                      onPressed: () {
                        _cancelChanges();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 20, 45, 85),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(
                        //     40.0,
                        //   ),
                        // ),
                      ),
                      onPressed: () {
                        _saveChanges();
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        currentStudent.profileImage = File(pickedFile.path);
      }
    });
  }

  void _togglePasswordVisibility() {
    // Toggle the obscureText property of the password field
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Widget _buildEditableField(
      {required TextEditingController controller,
      required String label,
      bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: !isEditing,
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: isEditing
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _toggleEdit();
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditablePasswordField(
      {required TextEditingController controller,
      required String label,
      required bool isVisible}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: !isEditing,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: isEditing
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              _togglePasswordVisibility();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _togglePasswordVisibility();
                              _toggleEdit();
                            },
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text("Error"),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ),
          ],
        );
      },
    );
  }
}
