import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatefulWidget {
  final String habitId;

  const AnalyticsScreen({required this.habitId});

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // Все дни недели
  final List<String> _allDays = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];

  List<String> _selectedDays = []; // Список выбранных дней

  @override
  void initState() {
    super.initState();
    _fetchHabitData();
  }

  // Метод для загрузки данных привычки
  void _fetchHabitData() async {
    final habitDoc = await FirebaseFirestore.instance.collection('habits').doc(widget.habitId).get();
    final habitData = habitDoc.data();

    setState(() {
      // Если данных нет, изначально все дни активны
      _selectedDays = List<String>.from(habitData?['repeat'] ?? _allDays);
    });
  }

  // Метод для обновления дней недели в Firestore
  void _updateRepeatDays() async {
    await FirebaseFirestore.instance.collection('habits').doc(widget.habitId).update({
      'repeat': _selectedDays,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Дни недели обновлены'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать привычку'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateRepeatDays, // Сохранение изменений
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('habits').doc(widget.habitId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final habit = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название привычки
                Text(
                  habit['title'] ?? 'Без названия',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Дни недели
                Text(
                  'Выберите дни недели:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: _allDays.map((day) => _buildDayChip(day)).toList(),
                ),
                SizedBox(height: 32),
                // Дополнительная информация
                Text(
                  'Current Streak: ${habit['streak'] ?? 0}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Best Streak: ${habit['bestStreak'] ?? 0}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Completed This Week: ${habit['completedThisWeek'] ?? 0}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Completion Rate: ${habit['completionRate'] ?? 0}%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Метод для создания интерактивного выбора дня недели
  Widget _buildDayChip(String day) {
    return ChoiceChip(
      label: Text(day),
      selected: _selectedDays.contains(day), // Все дни активны по умолчанию
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedDays.add(day);
          } else {
            _selectedDays.remove(day);
          }
        });
      },
      selectedColor: Colors.blue, // Цвет активных дней
      backgroundColor: Colors.grey[300], // Цвет неактивных дней
    );
  }
}
