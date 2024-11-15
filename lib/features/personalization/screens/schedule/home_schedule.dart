import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/validators/validation.dart';
import 'new.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();
  final _teacherController = TextEditingController();
  String? _selectedDay;
  String? _selectedBuilding;

  User? currentUser = FirebaseAuth.instance.currentUser;

  String get userId => currentUser?.uid ?? "";

  TimeOfDay? _startTime;

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _subjectController.dispose();
    _roomController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _addLesson() async {
    if (_startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _selectedBuilding == null ||
        _roomController.text.isEmpty ||
        _teacherController.text.isEmpty ||
        _selectedDay == null) {
      Get.snackbar('Ошибка', 'Все поля обязательны для заполнения',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey.withOpacity(0.3),
          colorText: Colors.black);
      return;
    }

    if (userId.isEmpty) {
      Get.snackbar('Ошибка',
          'Пользователь не авторизован. Пожалуйста, войдите в систему.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final newLesson = {
      'startTime': _startTimeController.text,
      'endTime': _endTimeController.text,
      'subject': _subjectController.text,
      'building': _selectedBuilding,
      'room': _roomController.text,
      'teacher': _teacherController.text,
      'day': _selectedDay,
    };

    lessonDone(context);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('lessons')
          .add(newLesson);

      _startTimeController.clear();
      _endTimeController.clear();
      _subjectController.clear();
      _roomController.clear();
      _teacherController.clear();
      setState(() {
        _selectedBuilding = null;
        _selectedDay = null;
        _startTime = null;
      });
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось добавить урок: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
          colorText: Colors.black);
    }
  }

  void _viewAllLessons() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => AllLessonsScreen(userId: userId)),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF3A6FF2),
              onPrimary: Colors.white,
              onSurface: Color(0xFF3A6FF2),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF3A6FF2),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _startTime = picked;
      _startTimeController.text = picked.format(context);

      final endMinutes = (picked.hour * 60 + picked.minute + 50) % 1440;
      final endHour = endMinutes ~/ 60;
      final endMinute = endMinutes % 60;
      final endPicked = TimeOfDay(hour: endHour, minute: endMinute);
      _endTimeController.text = endPicked.format(context);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF3A6FF2),
              onPrimary: Colors.white,
              onSurface: Color(0xFF3A6FF2),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF3A6FF2),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && _startTime != null) {
      final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endMinutes = picked.hour * 60 + picked.minute;

      if (endMinutes > startMinutes) {
        _endTimeController.text = picked.format(context);
      } else {
        Get.snackbar(
          'Ошибка',
          'Время конца должно быть больше времени начала.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
          colorText: Colors.black,
        );
      }
    }
  }

  Widget _buildTextField(
      {required TextEditingController controller,
        required String labelText,
        required TextInputType type}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFF3A6FF2)),
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF3A6FF2), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Расписание",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(onPressed: _viewAllLessons, child: Text("Посмотреть все", style: TextStyle(color: Colors.white),))
        ],
        backgroundColor: Color(0xFF3A6FF2),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                    controller: _subjectController,
                    labelText: "Предмет",
                    type: TextInputType.text),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectStartTime(context),
                        child: AbsorbPointer(
                          child: _buildTextField(
                              controller: _startTimeController,
                              labelText: "Время начала",
                              type: TextInputType.text),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectEndTime(context),
                        child: AbsorbPointer(
                          child: _buildTextField(
                              controller: _endTimeController,
                              labelText: "Время конца",
                              type: TextInputType.text),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildTextField(
                    controller: _roomController,
                    labelText: "Аудитория",
                    type: TextInputType.number),
                SizedBox(height: 16),
                _buildTextField(
                    controller: _teacherController,
                    labelText: "Преподаватель",
                    type: TextInputType.text),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedBuilding,
                  hint: Text(
                    "Выберите корпус",
                    style: TextStyle(
                      color: Color(0xFF3A6FF2),
                      fontSize: 14,
                    ),
                  ),
                  items: [
                    "Кабанбай батыр 8",
                    "Акан сара 11",
                    "Нарикбаева 2",
                    "Ауезова 46/1",
                  ].map((building) => DropdownMenuItem<String>(
                    value: building,
                    child: Text(
                      building,
                      style: TextStyle(
                        color: _selectedBuilding == building ? Colors.black : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  )).toList(),
                  decoration: InputDecoration(
                    labelText: "Корпус",
                    labelStyle: TextStyle(
                      color: Color(0xFF3A6FF2),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF3A6FF2), width: 2),
                    ),
                  ),
                  dropdownColor: Color(0xFF3A6FF2).withOpacity(0.8),
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF3A6FF2), size: 30),
                  onChanged: (value) {
                    setState(() {
                      _selectedBuilding = value;
                    });
                  },
                  isExpanded: true,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDay,
                  hint: Text(
                    "Выберите день недели",
                    style: TextStyle(
                      color: Color(0xFF3A6FF2),
                      fontSize: 14,
                    ),
                  ),
                  items: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
                      .map((day) => DropdownMenuItem<String>(
                    value: day,
                    child: Text(
                      day,
                      style: TextStyle(
                        color: _selectedDay == day ? Colors.black : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: "День недели",
                    labelStyle: TextStyle(
                      color: Color(0xFF3A6FF2),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF3A6FF2), width: 2),
                    ),
                  ),
                  dropdownColor: Color(0xFF3A6FF2).withOpacity(0.8),
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF3A6FF2), size: 28),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _addLesson,
                  child: Text("Добавить урок"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3A6FF2),
                    padding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}