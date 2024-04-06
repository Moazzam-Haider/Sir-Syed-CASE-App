import 'package:flutter/material.dart';
import 'package:sir_syed_case/dashboard.dart';
import 'package:sir_syed_case/profile.dart';
import 'package:sir_syed_case/data.dart';
import 'package:sir_syed_case/schedule.dart';

class CoursePage extends StatefulWidget {
  @override
  CoursePageState createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage> {
  int _currentIndex = 2;
  bool isLoading = false;

  // Add ValueNotifiers for dropdown values
  late ValueNotifier<String> selectedSeason;
  late ValueNotifier<int> selectedYear;
  late ValueNotifier<String> editedSemester;
  late ValueNotifier<String> editedSeason;
  late ValueNotifier<int> editedYear;

  void initState() {
    super.initState();
    // Initialize dropdown values
    selectedSeason = ValueNotifier<String>('Fall');
    selectedYear = ValueNotifier<int>(DateTime.now().year);
  }

  Future<void> reloadCoursePage() async {
    // Show loading animation
    setState(() {
      isLoading = true;
    });

    // Simulate some async operation, e.g., fetching data from an API
    await Future.delayed(Duration(seconds: 1));

    // Update data and hide loading animation
    setState(() {
      isLoading = false;
    });
  }

  String tempSemesterName = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 20, 48, 85),
          foregroundColor: Colors.white,
          title: Center(
            child: Text(
              'Course Page',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search, color: Colors.white),
          //     onPressed: () {
          //       //showSemesterDialog(context);
          //     },
          //   ),
          // ],
        ),
        body: _buildBody(),
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
              reloadCoursePage();
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
              backgroundColor: const Color.fromARGB(255, 20, 48, 85),
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 20, 48, 85),
              icon: Icon(
                Icons.schedule,
              ),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 20, 48, 85),
              icon: Icon(
                Icons.library_books,
              ),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 20, 48, 85),
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
        floatingActionButton: _currentIndex == 2
            ? FloatingActionButton(
                onPressed: () {
                  showSemesterDialog(context);
                },
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: const Color.fromARGB(255, 156, 132, 58)
                // backgroundColor: const Color.fromARGB(255, 191, 179, 135),
                )
            : null, // Set to null to hide the button on other pages
      ),
    );
  }

  showSemesterDialog(BuildContext context) async {
    final selectedSemester = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select New Semester'),
          content: Container(
            width: double.minPositive,
            height: 200,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: getAvailableSemesters().map((semester) {
                      return ListTile(
                        title: Text(semester),
                        onTap: () {
                          semester = semester;
                          Navigator.pop(context, semester);
                          showCalendarDialog(context, semester);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selectedSemester != null) {
      setState(() {
        this.tempSemesterName = selectedSemester;
      });
    }
  }

  List<String> getAvailableSemesters() {
    List<String> availableSemesters = List.from(allSemesters);
    for (int i = 0; i < currentStudent.studentSemesters.length; i++) {
      availableSemesters.removeWhere((semester) =>
          currentStudent.studentSemesters[i].semesterName.contains(semester));
    }
    return availableSemesters;
  }

  showCalendarDialog(BuildContext context, String semester) async {
    final selectedCalenderYear = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Calendar Year for $semester'),
          content: Container(
            width: double.minPositive,
            height: 170,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Season:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    ValueListenableBuilder<String>(
                      valueListenable: selectedSeason,
                      builder: (context, value, child) {
                        return DropdownButton<String>(
                          value: value,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSeason.value =
                                  newValue ?? selectedSeason.value;
                              print('Selected Season ${selectedSeason.value}');
                            });
                          },
                          items: seasons
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Year: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 35),
                    ValueListenableBuilder<int>(
                      valueListenable: selectedYear,
                      builder: (context, value, child) {
                        return DropdownButton<int>(
                          value: value,
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedYear.value =
                                  newValue ?? selectedYear.value;
                              print('Selected Year ${selectedYear.value}');
                            });
                          },
                          items: List.generate(
                            DateTime.now().year - 2018 + 1,
                            (index) => DateTime.now().year - index,
                          ).map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 156, 132, 58),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 20, 48, 85),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          'semester': semester,
                          'season': selectedSeason.value,
                          'year': selectedYear.value,
                        });
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selectedCalenderYear != null) {
      Semester newSemester = new Semester();
      String inputString =
          '${selectedCalenderYear['semester']} - ${selectedCalenderYear['season']} ${selectedCalenderYear['year'].toString()}';
      newSemester.semesterName = inputString;

      setState(() {
        if (currentStudent.studentSemesters.isEmpty) {
          currentStudent.studentSemesters.add(newSemester);
          currentStudent.studentSemesters[0].isCurrent = true;
          print(currentStudent.studentSemesters.length);
        } else {
          currentStudent.studentSemesters.add(newSemester);
        }
      });
    }
  }

  void showCourseSelectionDialog(BuildContext context, int semesterIndex) {
    List<Course> tempCourses = [];
    List<Course> currentCourses =
        currentStudent.studentSemesters[semesterIndex].semesterCourses;

    List<Course> availableCourses = predefinedCourses
        .where((course) => !currentCourses.contains(course))
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Courses for ${currentStudent.studentSemesters[semesterIndex].semesterName}',
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: double.minPositive,
                height: 300,
                child: ListView.builder(
                  itemCount: availableCourses.length,
                  itemBuilder: (context, courseIndex) {
                    return CheckboxListTile(
                      title: Text(availableCourses[courseIndex].name),
                      value:
                          tempCourses.contains(availableCourses[courseIndex]),
                      // activeColor: Color.fromARGB(255, 20, 48, 85),
                      activeColor: Color.fromARGB(255, 156, 132, 58),
                      checkColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            if (!tempCourses
                                .contains(availableCourses[courseIndex])) {
                              tempCourses.add(availableCourses[courseIndex]);
                            }
                          } else {
                            tempCourses.remove(availableCourses[courseIndex]);
                          }
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentStudent.studentSemesters[semesterIndex].semesterCourses
                      .addAll(tempCourses);
                  Navigator.pop(context);
                });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    currentStudent.studentSemesters
        .sort((a, b) => b.semesterName.compareTo(a.semesterName));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24),
        if (isLoading)
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: currentStudent.studentSemesters.length,
            itemBuilder: (context, index) {
              final semesterName =
                  currentStudent.studentSemesters[index].semesterName;
              final isCurrentSemester =
                  currentStudent.studentSemesters[index].isCurrent;
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: RichText(
                          text: TextSpan(
                            text: isCurrentSemester
                                ? '$semesterName '
                                : semesterName,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            children: <TextSpan>[
                              if (isCurrentSemester)
                                TextSpan(
                                  text: '(Current)',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 156, 132,
                                        58), // Change the color as needed
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // Show dialog to make the semester current
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Current Semester Selection',
                                  style: TextStyle(fontSize: 20),
                                ),
                                content: RichText(
                                  text: TextSpan(
                                    text: 'Do you want to make ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${semesterName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' the current semester?',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Update semester isCurrent values
                                      setState(() {
                                        currentStudent.studentSemesters
                                            .forEach((semester) {
                                          semester.isCurrent = false;
                                        });
                                        currentStudent.studentSemesters[index]
                                            .isCurrent = true;
                                      });
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('Yes',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                showCourseSelectionDialog(context, index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                print('$index');
                                editSemester(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteSemester(index);
                              },
                            ),
                          ],
                        ),
                      ),
                      // Display selected courses below the semester
                      if (currentStudent
                          .studentSemesters[index].semesterCourses.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('No Courses Added'),
                        )
                      else
                        Column(
                          children: currentStudent
                              .studentSemesters[index].semesterCourses
                              .asMap()
                              .entries
                              .map(
                                (entry) => ListTile(
                                  title: Text(
                                    entry.value.name,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        currentStudent.studentSemesters[index]
                                            .semesterCourses
                                            .removeAt(entry.key);
                                      });
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  List<Course> getAvailableCourses(index) {
    List<Course> currentCourses =
        currentStudent.studentSemesters[index].semesterCourses;
    List<Course> availableCourses = predefinedCourses
        .where((course) => !currentCourses.contains(course))
        .toList();

    return availableCourses;
  }

  editSemester(int index) async {
    final editedItem = await showDialog(
      context: context,
      builder: (BuildContext context) {
        editedSemester = ValueNotifier<String>(currentStudent
            .studentSemesters[index].semesterName
            .split(' - ')[0]);
        editedSeason = ValueNotifier<String>(currentStudent
            .studentSemesters[index].semesterName
            .split(' - ')[1]
            .split(' ')[0]);
        editedYear = ValueNotifier<int>(int.parse(currentStudent
            .studentSemesters[index].semesterName
            .split(' - ')[1]
            .split(' ')[1]));

        return AlertDialog(
          title: Text('Edit Calendar Year for ${editedSemester.value}'),
          content: Container(
            width: double.minPositive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('Season: '),
                    SizedBox(width: 20),
                    ValueListenableBuilder<String>(
                      valueListenable: editedSeason,
                      builder: (context, value, child) {
                        return DropdownButton<String>(
                          value: value,
                          onChanged: (String? newValue) {
                            setState(() {
                              editedSeason.value =
                                  newValue ?? editedSeason.value;
                            });
                          },
                          items: seasons
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Year: '),
                    SizedBox(width: 35),
                    ValueListenableBuilder<int>(
                      valueListenable: editedYear,
                      builder: (context, value, child) {
                        return DropdownButton<int>(
                          value: value,
                          onChanged: (int? newValue) {
                            setState(() {
                              editedYear.value = newValue ?? editedYear.value;
                            });
                          },
                          items: List.generate(
                            DateTime.now().year - 2018 + 1,
                            (index) => DateTime.now().year - index,
                          ).map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 156, 132, 58),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 20, 48, 85),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          'semester': editedSemester.value,
                          'season': editedSeason.value,
                          'year': editedYear.value,
                        });
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (editedItem != null) {
      setState(() {
        currentStudent.studentSemesters[index].semesterName =
            '${editedItem['semester']} - ${editedItem['season']} ${editedItem['year']}';
      });
    }
    //showSemesterDialog(context);
  }

  // Method to remove both semester and associated courses
  void deleteSemester(int index) {
    setState(() {
      currentStudent.studentSemesters.removeAt(index);
    });
  }
}
