import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'habit_detail.dart';
import 'habit_new.dart';

class HabitHomeScreen extends StatefulWidget {
  @override
  _HabitHomeScreenState createState() => _HabitHomeScreenState();
}

class _HabitHomeScreenState extends State<HabitHomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // Получение дня недели
    final String selectedWeekDay = _selectedDay != null
        ? _weekDayToString(_selectedDay!.weekday)
        : _weekDayToString(DateTime.now().weekday);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              final confirmation = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Очистить все'),
                  content: Text('Вы уверены, что хотите удалить все привычки?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Да'),
                    ),
                  ],
                ),
              );

              if (confirmation == true) {
                final collection = FirebaseFirestore.instance.collection('habits');
                final snapshots = await collection.get();
                for (var doc in snapshots.docs) {
                  await doc.reference.delete();
                }

                // Уведомление пользователя
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Все привычки удалены.')),
                );

                // Обновление состояния
                setState(() {
                  _selectedDay = null; // Сбросить выбранный день
                  _focusedDay = DateTime.now(); // Вернуть фокус на текущий день
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
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
          // Недельный календарь
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.week,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: HeaderStyle(formatButtonVisible: false),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 16),
          // Заголовок списка привычек
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Привычки на $selectedWeekDay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {}); // Обновление экрана
                  },
                ),
              ],
            ),
          ),
          // Список привычек
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('habits').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final habits = snapshot.data!.docs;

                // Фильтрация привычек по выбранному дню недели
                final filteredHabits = habits.where((habit) {
                  final repeatDays = List<String>.from(habit['repeat'] ?? []);
                  return repeatDays.contains(selectedWeekDay);
                }).toList();

                if (filteredHabits.isEmpty) {
                  return Center(
                    child: Text(
                      'Нет привычек для выбранного дня.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredHabits.length,
                  itemBuilder: (context, index) {
                    final habit = filteredHabits[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: habit['color'] is int
                              ? Color(habit['color'])
                              : Color(int.parse(habit['color'])),
                          child: Text(habit['title'][0].toUpperCase()),
                        ),
                        title: Text(habit['title']),
                        subtitle: Text('Повтор: ${habit['repeat'].join(', ')}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnalyticsScreen(habitId: habit.id),
                            ),
                          );
                        },
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

  // Метод для преобразования номера дня недели в строку
  String _weekDayToString(int weekDay) {
    const days = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    return days[weekDay - 1];
  }
}
