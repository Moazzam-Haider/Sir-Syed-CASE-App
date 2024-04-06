import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:io';

class Course {
  String name;
  Color color;
  String? imageUrl;
  DateTime? startTime;
  DateTime? endTime;
  String? roomNumber;

  Course({required this.name, this.color = Colors.blue, this.imageUrl = null});
}

class Semester {
  List<Course> semesterCourses = [];
  String semesterName = '';
  bool isCurrent = false;
}

final List<String> allSemesters = [
  '1st Semester',
  '2nd Semester',
  '3rd Semester',
  '4th Semester',
  '5th Semester',
  '6th Semester',
  '7th Semester',
  '8th Semester',
];

List<String> seasons = ['Fall', 'Spring', 'Summer'];

List<Course> predefinedCourses = [
  Course(name: 'Software Construction and Development'),
  Course(name: 'Smart App Development'),
  Course(name: 'Web Engineering'),
  Course(name: 'Project Scheduling and Costing'),
  Course(name: 'Simulation and Modelling'),
  Course(name: 'Programming Fundamentals'),
  Course(name: 'Information and Communication Technology'),
  Course(name: 'Applied Physics'),
  Course(name: 'English Comprehension'),
  Course(name: 'Technical and Business Writing'),
  Course(name: 'Operational Research'),
  Course(name: 'Software Quality Assurance'),
  Course(name: 'Software Reengineering'),
  Course(name: 'Computer Communication and Networks'),
  Course(name: 'Professional Practices'),

  // Add more predefined subjects as needed
];
List<Course> addedCourses = [];

class Student {
  String firstName;
  String lastName;
  String fatherName;
  String cnic;
  String phone;
  String gender;
  String password;
  String confirmPassword;
  String batch;
  String rollNo;
  String email;
  String degree;
  File? profileImage;
  List<Semester> studentSemesters = [];

  Student(
    this.firstName,
    this.lastName,
    this.fatherName,
    this.cnic,
    this.phone,
    this.gender,
    this.password,
    this.confirmPassword,
    this.batch,
    this.rollNo,
    this.email,
    this.degree,
  );
}

Student currentStudent =
    Student('', '', '', '', '', '', '', '', '', '', '', '');

// Student currentStudent = Student(
//   'firstName',
//   'lastName',
//   'fatherName',
//   'cnic',
//   'gender',
//   'password',
//   'confirmPassword',
//   'batch',
//   'rollNo',
//   'email',
//   'degree',
// );

List<String> rooms = [
  'G01',
  'G02',
  'G03',
  'G04',
  'G05',
  'G06',
  'F01',
  'F02',
  'F03',
  'S01',
  'S02',
  'S03',
  'S04',
  'S05',
  'S06',
  'CS Computing Lab',
  'DLD Lab',
  'ECE Computing Lab',
  'Electrical Power and Machines Lab',
  'Electronics Lab',
  'Network and Cyber Security Lab',
  'Systems Lab',
];

// bool currentSemester =
//     currentStudent.studentSemesters.any((Semester) => Semester.isCurrent);

List<String> availableSubjects = [];
int currentSemesterIndex = -1;
// currentSemesterIndex = currentStudent.studentSemesters
//     .indexWhere((Semester) => Semester.isCurrent);

List<String> mySubjects = [];

class ClassInfo {
  String startTime = '';
  String endTime = '';
  String roomNumber = '';
  String subject = '';
  String day = '';
}

//List<ClassInfo> classes = [];
List<String> hours = [
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12'
];
List<String> minutes = ['00', '15', '30', '45'];
List<String> amPm = ['AM', 'PM'];

List<String> daysOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

final Map<String, List<ClassInfo>> groupedClasses = {};

Map<String, List<ClassInfo>> schedule = {
  'Monday': [],
  'Tuesday': [],
  'Wednesday': [],
  'Thursday': [],
  'Friday': [],
  'Saturday': [],
  'Sunday': [],
};

List<String> getAvailableSubjects() {
  currentSemesterIndex = currentStudent.studentSemesters
      .indexWhere((Semester) => Semester.isCurrent);

  availableSubjects = [''];

  if (currentSemesterIndex != -1) {
    availableSubjects.addAll(currentStudent
        .studentSemesters[currentSemesterIndex].semesterCourses
        .map((course) => course.name));
  }

  return availableSubjects;
}

List<ClassInfo> myClasses = [];
List<ClassInfo> classesToday = [];
List<ClassInfo> classesTomorrow = [];

String currentDay = '';

String getCurrentDay() {
  DateTime now = DateTime.now();
  String currentDay = '';

  switch (now.weekday) {
    case DateTime.monday:
      currentDay = 'Monday';
      break;
    case DateTime.tuesday:
      currentDay = 'Tuesday';
      break;
    case DateTime.wednesday:
      currentDay = 'Wednesday';
      break;
    case DateTime.thursday:
      currentDay = 'Thursday';
      break;
    case DateTime.friday:
      currentDay = 'Friday';
      break;
    case DateTime.saturday:
      currentDay = 'Saturday';
      break;
    case DateTime.sunday:
      currentDay = 'Sunday';
      break;
  }
  print('$currentDay');
  return currentDay;
}

// Future<void> FirebaseDataRetriever() async {
//     currentStudent.firstName = ''
// }