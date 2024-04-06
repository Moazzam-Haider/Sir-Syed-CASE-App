import 'package:flutter/material.dart';
import 'package:sir_syed_case/data.dart';
import 'package:sir_syed_case/dashboard.dart';
import 'package:sir_syed_case/course.dart';
import 'package:sir_syed_case/profile.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  //List<DaySchedule> daySchedules = [];

  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 1;
  bool isLoading = false;

  Future<void> reloadSchedulePage() async {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Schedules Page',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 20, 48, 85),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: schedule.keys.map((day) {
                return DayCard(
                  day: day,
                  classes: schedule[day]!,
                  onAddClass: (classDetails) {
                    setState(() {
                      schedule[day]!.add(classDetails);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
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
              reloadSchedulePage();
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
      ),
    );
  }
}

int index = -1;

class DayCard extends StatefulWidget {
  final String day;
  final List<ClassInfo> classes;
  final Function(ClassInfo) onAddClass;

  DayCard({
    required this.day,
    required this.classes,
    required this.onAddClass,
  });

  @override
  _DayCardState createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  Color cardColor = Colors.white;

  late ValueNotifier<String> selectedStartHour;
  late ValueNotifier<String> selectedStartMinute;
  late ValueNotifier<String> selectedStartAmPm;
  late ValueNotifier<String> selectedEndHour;
  late ValueNotifier<String> selectedEndMinute;
  late ValueNotifier<String> selectedEndAmPm;
  late ValueNotifier<String> selectedSubject;
  late ValueNotifier<String> selectedRoomNumber;

  @override
  void initState() {
    super.initState();
    selectedStartHour = ValueNotifier<String>('08');
    selectedStartMinute = ValueNotifier<String>('00');
    selectedStartAmPm = ValueNotifier<String>('AM');
    selectedEndHour = ValueNotifier<String>('09');
    selectedEndMinute = ValueNotifier<String>('00');
    selectedEndAmPm = ValueNotifier<String>('AM');
    selectedSubject = ValueNotifier<String>('');
    selectedRoomNumber = ValueNotifier<String>('G01');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.day == 'Monday' ||
        widget.day == 'Wednesday' ||
        widget.day == 'Friday' ||
        widget.day == 'Sunday') {
      cardColor = Colors.white;
    } else {
      cardColor = Colors.white70;
    }

    return Card(
      color: cardColor,
      // shadowColor: Colors.black87,
      // borderOnForeground: true,
      // surfaceTintColor: Colors.white70,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.day,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              widget.classes.isEmpty
                  ? Center(
                      child: Text(
                        'No Classes Added',
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.classes.map((classDetails) {
                        return ListTile(
                          title: Text(
                            'Class ${widget.classes.indexOf(classDetails) + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Subject: ${classDetails.subject}'),
                              SizedBox(height: 8),
                              Text(
                                  'Time: ${classDetails.startTime} - ${classDetails.endTime}'),
                              Text('Room: ${classDetails.roomNumber}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Handle edit functionality here
                                  _editClass(
                                      widget.classes.indexOf(classDetails));
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Handle delete functionality here
                                  _deleteClass(
                                      widget.classes.indexOf(classDetails));
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white60),
                  ),
                  onPressed: () {
                    if (currentStudent.studentSemesters.isEmpty) {
                      showErrorDialog('No Semester Added');
                    } else if (getAvailableSubjects().length == 0) {
                      showErrorDialog('No Subjects Added');
                    } else {
                      _addNewClass(context);
                    }
                  },
                  child: Text(
                    'Add Class',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewClass(context) {
    ClassInfo newClass = ClassInfo();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Add Class',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
            height: 220,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: double.maxFinite),
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedSubject,
                      builder: (context, value, child) {
                        return DropdownButton<String>(
                          value: value,
                          isExpanded: true,
                          isDense: true,
                          items: getAvailableSubjects()
                              .map<DropdownMenuItem<String>>((String subject) {
                            return DropdownMenuItem<String>(
                              value: subject,
                              child: Text(subject),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedSubject.value = newValue;
                            }
                          },
                          hint: Text('Select Subject'),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: selectedStartHour,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            //isExpanded: true,
                            items: hours.map((String hour) {
                              return DropdownMenuItem<String>(
                                value: hour,
                                child: Text(hour),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedStartHour.value = newValue;
                              }
                            },
                            hint: Text('Hour'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedStartMinute,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            //isExpanded: true,
                            items: minutes.map((String minute) {
                              return DropdownMenuItem<String>(
                                value: minute,
                                child: Text(minute),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedStartMinute.value = newValue;
                              }
                            },
                            hint: Text('Minute'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedStartAmPm,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            // isExpanded: true,
                            items: amPm.map((String amPm) {
                              return DropdownMenuItem<String>(
                                value: amPm,
                                child: Text(amPm),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedStartAmPm.value = newValue;
                              }
                            },
                            hint: Text('AM/PM'),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: selectedEndHour,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            //isExpanded: true,
                            items: hours.map((String hour) {
                              return DropdownMenuItem<String>(
                                value: hour,
                                child: Text(hour),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedEndHour.value = newValue;
                              }
                            },
                            hint: Text('Hour'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedEndMinute,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            // isExpanded: true,
                            items: minutes.map((String minute) {
                              return DropdownMenuItem<String>(
                                value: minute,
                                child: Text(minute),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedEndMinute.value = newValue;
                              }
                            },
                            hint: Text('Minute'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedEndAmPm,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            icon: Icon(Icons.timer),
                            value: value,
                            //isExpanded: true,
                            items: amPm.map((String amPm) {
                              return DropdownMenuItem<String>(
                                value: amPm,
                                child: Text(amPm),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedEndAmPm.value = newValue;
                              }
                            },
                            hint: Text('AM/PM'),
                          );
                        },
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: double.maxFinite,
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedRoomNumber,
                      builder: (context, value, child) {
                        return DropdownButton<String>(
                          value: value,
                          isExpanded: true,
                          isDense: true,
                          items: rooms.map((String room) {
                            return DropdownMenuItem<String>(
                              value: room,
                              child: Text(room),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedRoomNumber.value = newValue;
                            }
                          },
                          hint: Text('Room Number'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  newClass.subject = selectedSubject.value;
                  newClass.startTime =
                      '${selectedStartHour.value}:${selectedStartMinute.value} ${selectedStartAmPm.value}';
                  newClass.endTime =
                      '${selectedEndHour.value}:${selectedEndMinute.value} ${selectedEndAmPm.value}';
                  newClass.roomNumber = selectedRoomNumber.value;
                  newClass.day = widget.day;
                  widget.classes.add(newClass);
                  //myClasses.add(newClass);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Error",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Text(
                message,
                style: TextStyle(fontSize: 16),
              )),
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

  void _editClass(int classIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Edit Class',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
            height: 185,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: double.maxFinite),
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedSubject,
                      builder: (context, value, child) {
                        return DropdownButton<String>(
                          value: value,
                          isExpanded: true,
                          isDense: true,
                          items: getAvailableSubjects()
                              .map<DropdownMenuItem<String>>((String subject) {
                            return DropdownMenuItem<String>(
                              value: subject,
                              child: Text(subject),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedSubject.value = newValue;
                            }
                          },
                          hint: Text('Select Subject'),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: selectedStartHour,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            //isExpanded: true,
                            items: hours.map((String hour) {
                              return DropdownMenuItem<String>(
                                value: hour,
                                child: Text(hour),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedStartHour.value = newValue;
                              }
                            },
                            hint: Text('Hour'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedStartMinute,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            //isExpanded: true,
                            items: minutes.map((String minute) {
                              return DropdownMenuItem<String>(
                                value: minute,
                                child: Text(minute),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedStartMinute.value = newValue;
                              }
                            },
                            hint: Text('Minute'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedStartAmPm,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            // isExpanded: true,
                            items: amPm.map((String amPm) {
                              return DropdownMenuItem<String>(
                                value: amPm,
                                child: Text(amPm),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedStartAmPm.value = newValue;
                              }
                            },
                            hint: Text('AM/PM'),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: selectedEndHour,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            //isExpanded: true,
                            items: hours.map((String hour) {
                              return DropdownMenuItem<String>(
                                value: hour,
                                child: Text(hour),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedEndHour.value = newValue;
                              }
                            },
                            hint: Text('Hour'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedEndMinute,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            value: value,
                            // isExpanded: true,
                            items: minutes.map((String minute) {
                              return DropdownMenuItem<String>(
                                value: minute,
                                child: Text(minute),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedEndMinute.value = newValue;
                              }
                            },
                            hint: Text('Minute'),
                          );
                        },
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedEndAmPm,
                        builder: (context, value, child) {
                          return DropdownButton<String>(
                            icon: Icon(Icons.timer),
                            value: value,
                            //isExpanded: true,
                            items: amPm.map((String amPm) {
                              return DropdownMenuItem<String>(
                                value: amPm,
                                child: Text(amPm),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedEndAmPm.value = newValue;
                              }
                            },
                            hint: Text('AM/PM'),
                          );
                        },
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: double.maxFinite,
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: selectedRoomNumber,
                      builder: (context, value, child) {
                        return DropdownButton<String>(
                          value: value,
                          isExpanded: true,
                          items: rooms.map((String room) {
                            return DropdownMenuItem<String>(
                              value: room,
                              child: Text(room),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedRoomNumber.value = newValue;
                            }
                          },
                          hint: Text('Room Number'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.classes[classIndex].subject = selectedSubject.value;
                  widget.classes[classIndex].startTime =
                      '${selectedStartHour.value}:${selectedStartMinute.value} ${selectedStartAmPm.value}';
                  widget.classes[classIndex].endTime =
                      '${selectedEndHour.value}:${selectedEndMinute.value} ${selectedEndAmPm.value}';
                  widget.classes[classIndex].roomNumber =
                      selectedRoomNumber.value;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to delete a class
  void _deleteClass(int classIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Confirm Deletion",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Are you sure you want to Delete this Class?",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.classes.removeAt(classIndex);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    selectedSubject.dispose();
    selectedStartHour.dispose();
    selectedStartMinute.dispose();
    selectedStartAmPm.dispose();
    selectedEndHour.dispose();
    selectedEndMinute.dispose();
    selectedEndAmPm.dispose();

    super.dispose();
  }
}
