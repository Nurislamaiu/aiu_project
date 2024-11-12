import 'package:aiu_project/features/personalization/models/task_model.dart';
import 'package:aiu_project/features/personalization/screens/habit/models/habit.dart';
import 'package:aiu_project/features/personalization/screens/task/data/hive_data_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'app.dart';

Future<void> main() async {
  // Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Hive initialization
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter<TaskModel>(TaskModelAdapter());

  // Open boxes
  var taskBox = await Hive.openBox<TaskModel>(HiveDataStore.boxName);

  // Clean up old tasks that aren't from today
  taskBox.values.forEach((task) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    }
  });

  // Run the app with MultiProvider for all the providers
  runApp(ChangeNotifierProvider(
      create: (context) => habitAdapter, // Ensure habitAdapter is defined properly
      child: BaseWidget(child: App()),
    ),);
}

class BaseWidget extends InheritedWidget {
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child);

  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor Widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false; // No need to notify updates in this case
  }
}
