import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    final String selectedWeekDay = _selectedDay != null
        ? _weekDayToString(_selectedDay!.weekday)
        : _weekDayToString(DateTime.now().weekday);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Habit Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [secondaryColor.withOpacity(0.8), primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [secondaryColor, primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Привычки на $selectedWeekDay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: primaryColor),
                  tooltip: 'Обновить список',
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('habits').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final habits = snapshot.data!.docs;

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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredHabits.length,
                  itemBuilder: (context, index) {
                    final habit = filteredHabits[index];

                    // Получаем цвет и значок из Firestore
                    final colorValue = habit['color'] ?? 0xFF000DFF; // Если цвет отсутствует, используем основной
                    final Color color = Color(colorValue); // Преобразуем значение цвета в Color
                    final iconIndex = habit['icon'] ?? -1; // Проверяем индекс значка
                    final IconData icon = (iconIndex >= 0 && iconIndex < _icons.length)
                        ? _icons[iconIndex]
                        : Icons.help_outline; // Значок по умолчанию, если индекс некорректен

                    return Card(
                      color: color.withOpacity(0.8), // Цвет карточки с прозрачностью
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: Icon(
                            icon,
                            color: Colors.white,
                            size: 24,
                        ),
                        title: Text(
                          habit['title'],
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
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

    if (confirmation == true) {
      final collection = FirebaseFirestore.instance.collection('habits');
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Все привычки удалены.')),
      );
    }
  }

  String _weekDayToString(int weekDay) {
    const days = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    return days[weekDay - 1];
  }
}
