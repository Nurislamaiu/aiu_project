import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  TaskModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.createdAtTime,
    required this.createdAtDate,
    required this.isCompleted,
  });

  @HiveField(0) // id
  final String id;
  @HiveField(1) // title
  String title;
  @HiveField(2) // sub title
  String subTitle;
  @HiveField(3) // time
  DateTime createdAtTime;
  @HiveField(4) // date
  DateTime createdAtDate;
  @HiveField(5) // completed
  bool isCompleted;

  factory TaskModel.create({
    required String? title,
    required String? subTitle,
    DateTime? createdAtTime,
    DateTime? createdAtDate,
  }) =>
      TaskModel(
          id: const Uuid().v1(),
          title: title ?? "",
          subTitle: subTitle ?? "",
          createdAtTime: createdAtTime ?? DateTime.now(),
          createdAtDate: createdAtDate ?? DateTime.now(),
          isCompleted: false);
}
