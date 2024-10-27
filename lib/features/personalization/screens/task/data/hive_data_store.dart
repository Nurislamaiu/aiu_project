import 'package:aiu_project/features/personalization/models/task_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


/// All the [CRUD] operation method For Hive DB
class HiveDataStore{

  /// Box Name
  static const boxName = 'taskBox';

  /// Our current Box with all the saved data inside - Box<TaskModel>
  final Box<TaskModel> box = Hive.box<TaskModel>(boxName);


  /// Add New Task To Box
  Future<void> addTask ({required TaskModel task})async{
    await box.put(task.id, task);
  }

  /// Show Task
  Future<TaskModel?> getTask({required String id})async{
    return box.get(id);
  }

  /// Update Task
  Future<void> updateTask({required TaskModel task})async{
    await task.save();
  }

  /// Delete Task
  Future<void> deleteTask({required TaskModel task})async{
    await task.delete();
  }

  /// Listen to Box Changes
  ValueListenable<Box<TaskModel>> listenToTask() => box.listenable();
}