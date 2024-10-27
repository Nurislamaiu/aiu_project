import 'package:aiu_project/features/personalization/models/task_model.dart';
import 'package:aiu_project/features/personalization/screens/task/data/hive_data_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'app.dart';

Future<void> main() async {
  /// Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// Init Hive DB before run App
  await Hive.initFlutter();

  /// Register Hive Adapter
  Hive.registerAdapter<TaskModel>(TaskModelAdapter());

  /// Open Box
  var box = await Hive.openBox<TaskModel>(HiveDataStore.boxName);

  box.values.forEach(
    (task) {
      if (task.createdAtTime.day != DateTime.now().day) {
        task.delete();
      } else {
        /// Do nothing
      }
    },
  );
  runApp(BaseWidget(child: App()));
}

class BaseWidget extends InheritedWidget{
  BaseWidget({Key? key, required this.child}): super(key: key, child: child);
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;


  static BaseWidget of(BuildContext context){
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if(base != null){
      return base;
    }else{
      throw StateError('Could not find ancestor Widget of type BaseWidget');
    }
  }


  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
  
}
