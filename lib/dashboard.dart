import 'package:flutter/material.dart';
import 'package:sir_syed_case/course.dart';
import 'package:sir_syed_case/profile.dart';
import 'package:sir_syed_case/schedule.dart';
import 'package:sir_syed_case/data.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool isLoading = false;

  // List<ClassInfo> upComingClasses = [];

  Future<void> reloadHomePage() async {
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

  // Method to update subjects and classes data
  // void updateData(List<String> newSubjects, List<ClassInfo> newClasses) {
  //   setState(() {
  //     // subjects = newSubjects;
  //     //  upcomingClasses = newClasses;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    mySubjects = getAvailableSubjects();
    currentDay = getCurrentDay();

    myClasses = schedule[currentDay]!;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Sir Syed CASE University',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 20, 48, 85),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Subjects',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Horizontal List of Subjects
            Container(
              height: 100,
              child: mySubjects.isEmpty
                  ? Center(
                      child: Text(
                        'No Subjects to Show',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      //addAutomaticKeepAlives: false,
                      children: mySubjects
                          .map((subject) => SubjectTile(subject))
                          .toList(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Upcoming Classes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Vertical List of Upcoming Classes
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                child: myClasses.isEmpty
                    ? Center(
                        child: Text('No Classes Today'),
                      )
                    : ListView(
                        children: myClasses
                            .map((classInfo) => ClassTile(classInfo))
                            .toList(),
                      ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              reloadHomePage();
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
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

class SubjectTile extends StatelessWidget {
  final String subjectName;

  SubjectTile(this.subjectName);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 207, 210, 212),
        borderRadius: BorderRadius.circular(16.0),
        shape: BoxShape.rectangle,
      ),
      child: Center(
        child: Text(
          subjectName,
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}

class ClassTile extends StatelessWidget {
  final ClassInfo classInfo;

  ClassTile(this.classInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        color: const Color.fromARGB(255, 191, 179, 135),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classInfo.subject,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(
                Icons.room,
                size: 18.0,
              ),
              SizedBox(width: 4.0),
              Text('Room: ${classInfo.roomNumber}'),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18.0,
              ),
              SizedBox(width: 4.0),
              Text('Time: ${classInfo.startTime} - ${classInfo.endTime}'),
            ],
          ),
        ],
      ),
    );
  }
}
