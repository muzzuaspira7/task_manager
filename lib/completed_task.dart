// import 'package:flutter/material.dart';
// import 'package:task_manager/notes.dart';
// import 'db_handler.dart';

// class CompletedTask extends StatefulWidget {
//   const CompletedTask({Key? key}) : super(key: key);

//   @override
//   State<CompletedTask> createState() => _CompletedTaskState();
// }

// class _CompletedTaskState extends State<CompletedTask> {
//   late DBHelper? dbHelper;
//   late Future<List<NotesModel>> completedTasksList;

//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DBHelper();
//     loadCompletedTasks();
//   }

//   loadCompletedTasks() {
//     completedTasksList = dbHelper!.getCompletedTasksList();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Completed Tasks'),
//       ),
//       body: FutureBuilder(
//         future: completedTasksList,
//         builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
//           if (!snapshot.hasData ||
//               snapshot.data == null ||
//               snapshot.data!.isEmpty) {
//             return Center(
//               child: Text('No completed tasks.'),
//             );
//           } else {
//             return completedTasksView(snapshot.data!);
//           }
//         },
//       ),
//     );
//   }

//   Widget completedTasksView(List<NotesModel> data) {
//     return ListView.builder(
//       itemCount: data.length,
//       itemBuilder: (context, index) {
//         return Card(
//           child: ListTile(
//             title: Text(
//               data[index].title.toString(),
//               style: TextStyle(fontSize: 18),
//             ),
//             subtitle: Text(data[index].description.toString()),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(data[index].date.toString()),
//                 Text(data[index].time.toString()),
//                 Checkbox(
//                   value: data[index].isCompleted,
//                   onChanged: (value) {
//                     // Handle checkbox change if needed
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
