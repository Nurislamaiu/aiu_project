import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:table_calendar/table_calendar.dart';
import 'habit_detail.dart';
import 'habit_new.dart';

class HabitHomeScreen extends StatefulWidget {
  @override
  _HabitHomeScreenState createState() => _HabitHomeScreenState();
}

class _HabitHomeScreenState extends State<HabitHomeScreen> {
  static const Color primaryColor = Color(0xFF000DFF);
  static const Color secondaryColor = Color(0xFF5E5CE6);
  static const Color backgroundColor = Color(0xFFF8F9FA);

  final List<IconData> _icons = [
    Iconsax.activity,
    Iconsax.add_circle,
    Iconsax.add_square,
    Iconsax.airplane,
    Iconsax.alarm,
    Iconsax.arrow,
    Iconsax.bag,
    Iconsax.battery_charging,
    Iconsax.bitcoin_card,
    Iconsax.book,
    Iconsax.brush,
    Iconsax.call,
    Iconsax.camera,
    Iconsax.card,
    Iconsax.message,
    Iconsax.cloud,
    Iconsax.note,
    Iconsax.cup,
    Iconsax.music_dashboard,
    Iconsax.profile_delete,
    Iconsax.document,
    Iconsax.edit,
    Iconsax.folder,
    Iconsax.graph,
    Iconsax.heart,
    Iconsax.home,
    Iconsax.music,
    Iconsax.notification,
    Iconsax.search_favorite,
    Iconsax.setting,
  ];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? get userId {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        body: Center(child: Text('Пожалуйста, войдите в аккаунт')),
      );
    }

    final String selectedWeekDay = _selectedDay != null
        ? _weekDayToString(_selectedDay!.weekday)
        : _weekDayToString(DateTime.now().weekday);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<double>(
              future: _calculateCompletionRate(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Загрузка данных...',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Ошибка загрузки',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  );
                } else {
                  final completionRate = snapshot.data ?? 0.0;

                  // Используем _selectedDay или текущий день, если _selectedDay не установлен
                  final selectedDate = _selectedDay ?? _focusedDay;
                  final selectedWeekDay = _weekDayToString(selectedDate.weekday);
                  final selectedDateFormatted =
                      '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}';

                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: completionRate),
                    duration: Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$selectedWeekDay'),
                          Text(
                            '${value.toStringAsFixed(1)}% выполнено',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Iconsax.close_square),
            tooltip: 'Очистить все привычки',
            onPressed: _clearAllHabits,
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Добавить привычку',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddHabitScreen()),
              );
            },
          ),
        ],
      ),
        body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5E5CE6), // Secondary color
                  Color(0xFF000DFF), // Primary color
                  Color(0xFF082FA1), // Дополнительный цвет
                ],
                stops: [0.0, 0.5, 1.0], // Уровни распределения цветов
                begin: Alignment.topLeft, // Начало градиента
                end: Alignment.bottomRight, // Конец градиента
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.week,
              onDaySelected: (selectedDay, focusedDay) {
                if (!selectedDay
                    .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                } else {
                  Get.snackbar('Ошибка', 'Вы не можете выбрать этот день');
                }
              },
              headerStyle: HeaderStyle(
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleCentered: false,
                formatButtonVisible: false,
                formatButtonShowsNext: false,
                titleTextStyle:
                    TextStyle(color: Colors.transparent, fontSize: 1),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.white,
                ),
                weekendStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.5),
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                outsideTextStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('habits')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final habits = snapshot.data!.docs;

                // Текущая дата
                final DateTime today = DateTime.now();
                final String todayWeekDay = _weekDayToString(
                    today.weekday); // "Понедельник", "Вторник", и т.д.

                // Фильтруем задачи
                final filteredHabits = habits.where((habit) {
                  final List<dynamic> repeatDays = habit['repeat'] ?? [];
                  final List<dynamic> completedDates =
                      habit['datesCompleted'] ?? [];

                  // Проверяем, если текущий день или будущий день входит в repeat
                  final bool isFutureOrTodayTask = repeatDays.any((day) {
                    final DateTime nextOccurrence = _nextWeekDayOccurrence(day);
                    return !nextOccurrence
                        .isBefore(today); // Будущая дата или сегодня
                  });

                  return isFutureOrTodayTask;
                }).toList();

                if (filteredHabits.isEmpty) {
                  return Center(
                    child: Text(
                      'Нет задач для выбранного дня.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 70.0),
                  itemCount: filteredHabits.length,
                  itemBuilder: (context, index) {
                    final habit = filteredHabits[index];
                    final List<dynamic> completedDates =
                        habit['datesCompleted'] ?? [];
                    final String todayString =
                        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
                    final bool isCompletedToday =
                        completedDates.contains(todayString);

                    // Получаем цвет и значок привычки
                    final colorValue = habit['color'] ?? 0xFF000DFF;
                    final Color color = Color(colorValue);
                    final iconIndex = habit['icon'] ?? -1;
                    final IconData icon =
                        (iconIndex >= 0 && iconIndex < _icons.length)
                            ? _icons[iconIndex]
                            : Icons.help_outline;

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: completedDates.contains(todayString) &&
                                  _isSameDate(DateTime.now(),
                                      _selectedDay ?? DateTime.now())
                              ? [
                                  Colors.grey,
                                  Colors.grey
                                ] // Серый фон только для сегодняшних задач
                              : [color.withOpacity(1), color.withOpacity(0.1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: completedDates.contains(todayString) &&
                                    _isSameDate(DateTime.now(),
                                        _selectedDay ?? DateTime.now())
                                ? 10
                                : 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: Icon(icon, color: Colors.white, size: 32),
                        title: Text(
                          habit['title'],
                          style: TextStyle(
                            color: completedDates.contains(todayString) &&
                                    _isSameDate(DateTime.now(),
                                        _selectedDay ?? DateTime.now())
                                ? Colors.grey.shade300
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: _isSameDate(
                                _selectedDay ?? DateTime.now(), DateTime.now())
                            ? IconButton(
                                icon: Icon(
                                  completedDates.contains(todayString)
                                      ? Iconsax.activity
                                      : Icons.check,
                                  color: completedDates.contains(todayString)
                                      ? Colors.grey.shade300
                                      : Colors.white,
                                ),
                                onPressed: () async {
                                  final DateTime now = DateTime.now();
                                  final String todayString =
                                      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                                  if (completedDates.contains(todayString)) {
                                    // Удаляем сегодняшнюю дату из списка выполненных
                                    completedDates.remove(todayString);
                                  } else {
                                    // Добавляем сегодняшнюю дату в список выполненных
                                    completedDates.add(todayString);
                                  }

                                  // Обновляем данные в Firebase
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .collection('habits')
                                      .doc(habit.id)
                                      .update(
                                          {'datesCompleted': completedDates});

                                  setState(() {}); // Обновляем UI
                                },
                              )
                            : null, // Убираем кнопку, если дата не текущая
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllHabits() async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Очистить все привычки'),
        content: Text('Вы уверены, что хотите удалить все привычки?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmation == true && userId != null) {
      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('habits');
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      Get.snackbar('Успешно', 'Все задачи удалены');
    }
  }

  Future<double> _calculateCompletionRate() async {
    if (userId == null) return 0.0;

    final today = DateTime.now();
    final todayString =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('habits')
        .get();

    final habits = snapshot.docs;
    if (habits.isEmpty) return 0.0;

    int completedTasks = 0;

    for (var habit in habits) {
      final List<dynamic> completedDates = habit['datesCompleted'] ?? [];
      if (completedDates.contains(todayString)) {
        completedTasks++;
      }
    }

    // Вычисляем процент выполненных задач
    return (completedTasks / habits.length) * 100;
  }


  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _weekDayToString(int weekDay) {
    const days = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    return days[weekDay - 1];
  }

// Функция для определения следующей даты, соответствующей дню недели
  DateTime _nextWeekDayOccurrence(String weekDay) {
    const daysMap = {
      'Понедельник': 1,
      'Вторник': 2,
      'Среда': 3,
      'Четверг': 4,
      'Пятница': 5,
      'Суббота': 6,
      'Воскресенье': 7,
    };

    final int targetWeekDay = daysMap[weekDay]!;
    final DateTime today = DateTime.now();
    final int difference = (targetWeekDay - today.weekday + 7) % 7;

    return today.add(Duration(days: difference == 0 ? 0 : difference));
  }
}
