// class NotesModel {
//   final int? id;
//   final String title;
//   final String date;
//   final String description;
//   final String time;
//   final bool isCompleted;
//   // late final bool isCompleted;

//   NotesModel(
//       {required this.title,
//       required this.date,
//       required this.description,
//       required this.time,
//       // this.isCompleted = false,
//       this.id,
//       this.isCompleted = false});

//   NotesModel.fromMap(Map<String, dynamic> res)
//       : id = res['id'],
//         title = res['title'],
//         description = res['description'],
//         time = res['time'],
//         date = res['date'],
//         isCompleted = res['isCompleted'] == 1;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'time': time,
//       'date': date,
//       'isCompleted': isCompleted
//       // 'isCompleted': isCompleted,
//     };
//   }
// }

class NotesModel {
  final int? id;
  final String title;
  final String date;
  final String description;
  final String time;
  final bool isCompleted;

  NotesModel({
    required this.title,
    required this.date,
    required this.description,
    required this.time,
    this.id,
    this.isCompleted = false,
  });

  NotesModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        time = res['time'],
        date = res['date'],
        isCompleted = res['isCompleted'] == 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'date': date,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  NotesModel copyWith({
    int? id,
    String? title,
    String? date,
    String? description,
    String? time,
    bool? isCompleted,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
