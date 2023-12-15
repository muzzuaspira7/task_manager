import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/notes.dart';
import 'package:task_manager/utils/app_colors.dart';
import 'db_handler.dart';
import 'completed_task.dart';
import 'SplashScreen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  late Future<List<NotesModel>> completedTasksList;

  int _currentPageIndex = 0; //To Track the current page Index
  late PageController _pageController;
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadNotesList();
    loadCompletedTasksList();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  loadNotesList() {
    notesList = dbHelper!.getNotesList();
    setState(() {});
  }

  loadCompletedTasksList() {
    completedTasksList = dbHelper!.getCompletedTasksList();
    setState(() {});
  }

  void moveToCompletedTasks(NotesModel task) {
    dbHelper!.update(task.copyWith(isCompleted: true));
    loadNotesList();
    loadCompletedTasksList();
  }

  void moveToPendingTasks(NotesModel task) {
    dbHelper!.update(task.copyWith(isCompleted: false));
    loadNotesList();
    loadCompletedTasksList();
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       resizeToAvoidBottomInset: true,
  //       appBar: AppBar(
  //         title: Text(
  //           'Task Manager',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         backgroundColor: Color(0xFF002D5C),
  //       ),
  //       body: PageView(
  //         controller: _pageController,
  //         children: [
  //           FutureBuilder(
  //             future: notesList,
  //             builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
  //               if (!snapshot.hasData ||
  //                   snapshot.data == null ||
  //                   snapshot.data!.isEmpty) {
  //                 return emptyNotesWidget();
  //               } else {
  //                 return notesListView(snapshot.data!);
  //               }
  //             },
  //           ),
  //           // Second page
  //           FutureBuilder(
  //             future: completedTasksList,
  //             builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
  //               if (!snapshot.hasData ||
  //                   snapshot.data == null ||
  //                   snapshot.data!.isEmpty) {
  //                 return notCompletedWidget();
  //               } else {
  //                 return completedTasksView(snapshot.data!);
  //               }
  //             },
  //           ),
  //         ],
  //       ),
  //       floatingActionButton: _buildFloatingActionButton(),
  //       bottomNavigationBar: _buildBottomNavigationBar());
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appColor().navyBlue,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          FutureBuilder(
            future: notesList,
            builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return emptyNotesWidget();
              } else {
                return notesListView(snapshot.data!);
              }
            },
          ),
          FutureBuilder(
            future: completedTasksList,
            builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return notCompletedWidget();
              } else {
                return completedTasksView(snapshot.data!);
              }
            },
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    // Display FAB only on the first page
    return _currentPageIndex == 0
        ? FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 0, 90, 186),
            onPressed: () {
              _showBottomSheet(context);
            },
            child: Icon(Icons.add),
          )
        : SizedBox.shrink(); // You can return an empty SizedBox for other pages
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF002D5C),
      currentIndex: _currentPageIndex,
      selectedItemColor: Colors.white, // Set selected item color
      unselectedItemColor:
          const Color.fromARGB(123, 255, 255, 255), // Set unselected item color
      onTap: (index) {
        setState(() {
          _currentPageIndex = index;
        });
        _pageController.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.done_all,
            color: Colors.white,
          ),
          label: 'Completed',
        ),
      ],
    );
  }

  Widget emptyNotesWidget() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF001F3F),
            Color(0xFF002D5C),
            Color(0xFF001F3F),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/nothing-to-do-removed.png'),
              width: 250,
            ),
          ),
          Text(
            'Nothing to do...',
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
        ],
      ),
    );
  }

  //For not completed
  Widget notCompletedWidget() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF001F3F),
            Color(0xFF002D5C),
            Color(0xFF001F3F),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image(
              image: AssetImage('assets/images/nothing-to-do-removed.png'),
              width: 250,
            ),
          ),
          Text(
            'Complete Your Task',
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
        ],
      ),
    );
  }

  Widget notesListView(List<NotesModel> data) {
    //Filter
    List<NotesModel> pendingTasks =
        data.where((task) => !task.isCompleted).toList();
    pendingTasks = pendingTasks.reversed.toList(); // Reverse the list

    return ListView.builder(
      shrinkWrap: true,
      itemCount: pendingTasks.length,
      itemBuilder: (context, index) {
        return Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Color.fromARGB(255, 86, 168, 250),
            child: Icon(Icons.delete_forever_outlined),
          ),
          onDismissed: (DismissDirection direction) {
            setState(() {
              dbHelper!.delete(data[index].id);
              notesList = dbHelper!.getNotesList();
              data.remove(data[index]);
            });
          },
          key: ValueKey(data[index].id),
          child: InkWell(
            onTap: () {
              _showBottomSheet(context, existingNote: pendingTasks[index]);
            },
            child: Card(
              child: ListTile(
                leading: InkWell(
                  child: Checkbox(
                    value: pendingTasks[index].isCompleted,
                    onChanged: (value) {
                      // Handle checkbox change if needed
                      setState(() {
                        data[index] =
                            pendingTasks[index].copyWith(isCompleted: value);
                        dbHelper!.update(data[index]);
                        if (value!) {
                          moveToCompletedTasks(pendingTasks[index]);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    print('Checked');
                    // You can add additional logic here if needed
                  },
                ),
                title: Text(
                  pendingTasks[index].title.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(pendingTasks[index].description.toString()),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(pendingTasks[index].date.toString()),
                    Text(pendingTasks[index].time.toString()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, {NotesModel? existingNote}) {
    TextEditingController titleController =
        TextEditingController(text: existingNote?.title ?? "");
    TextEditingController descriptionController =
        TextEditingController(text: existingNote?.description ?? "");
    TextEditingController dateController =
        TextEditingController(text: existingNote?.date ?? "");
    TextEditingController timeController =
        TextEditingController(text: existingNote?.time ?? "");

    Future<void> _selectDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: existingNote?.date != null
            ? DateFormat('yyy-MM-dd').parse(existingNote!.date!)
            : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != DateTime.now()) {
        final formattedDate = DateFormat('yyy-MM-dd').format(picked);
        setState(() {
          dateController.text = formattedDate;
        });
      }
    }

    Future<void> _selectTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: existingNote?.time != null
            ? TimeOfDay.fromDateTime(
                DateFormat('HH:mm').parse(existingNote!.time!))
            : TimeOfDay.now(),
      );

      if (picked != null) {
        setState(() {
          timeController.text = picked.format(context);
        });
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: 'Select Date'),
                    onTap: () => _selectDate(),
                  ),
                  TextField(
                    controller: timeController,
                    decoration: InputDecoration(labelText: 'Select Time'),
                    onTap: () => _selectTime(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty) {
                        // Show Snackbar if the title is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(bottom: 590.0),
                            content: Text('Title cannot be empty'),
                          ),
                        );
                      } else {
                        if (existingNote != null) {
                          dbHelper!
                              .update(
                            NotesModel(
                              id: existingNote.id,
                              title: titleController.text,
                              description: descriptionController.text,
                              date: dateController.text,
                              time: timeController.text,
                            ),
                          )
                              .then((value) {
                            print("Updated");
                            setState(() {
                              notesList = dbHelper!.getNotesList();
                            });
                          }).onError((error, StackTrace) {
                            print("Error: $error");
                            print(StackTrace);
                          });
                        } else {
                          dbHelper!
                              .insert(
                            NotesModel(
                              title: titleController.text,
                              date: dateController.text,
                              description: descriptionController.text,
                              time: timeController.text,
                            ),
                          )
                              .then((value) {
                            print("Data Added");
                            setState(() {
                              notesList = dbHelper!.getNotesList();
                            });
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget completedTasksView(List<NotesModel> data) {
    List<NotesModel> completedTasks =
        data.where((task) => task.isCompleted).toList();

    return ListView.builder(
      itemCount: completedTasks.length,
      itemBuilder: (context, index) {
        return Card(
          color: Color(0xFFE2E5DE),
          child: ListTile(
            leading: InkWell(
              child: Checkbox(
                value: completedTasks[index].isCompleted,
                onChanged: (value) {
                  setState(() {
                    completedTasks[index] =
                        completedTasks[index].copyWith(isCompleted: value);
                    dbHelper!.update(completedTasks[index]);

                    if (!value!) {
                      moveToPendingTasks(completedTasks[index]);
                    }
                  });
                },
              ),
              onTap: () {
                print('Checked');
              },
            ),
            title: Text(
              completedTasks[index].title.toString(),
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(completedTasks[index].description.toString()),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(completedTasks[index].date.toString()),
                Text(completedTasks[index].time.toString()),
              ],
            ),
          ),
        );
      },
    );
  }
}
