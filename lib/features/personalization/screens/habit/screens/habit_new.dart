import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  static const Color primaryColor = Color(0xFF000DFF);
  static const Color secondaryColor = Color(0xFF5E5CE6);
  static const Color backgroundColor = Color(0xFFF8F9FA);

  final TextEditingController _titleController = TextEditingController();

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

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
  ];

  IconData _selectedIcon = Iconsax.activity;
  Color _selectedColor = Colors.blue;

  final List<String> _allDays = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];
  List<String> _selectedDays = [];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(_allDays);
  }

  void _createHabit() async {
    if (_titleController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('habits').add({
        'title': _titleController.text,
        'icon': _icons.indexOf(_selectedIcon),
        'color': _colors.indexOf(_selectedColor),
        'repeat': _selectedDays,
        'streak': 0,
        'bestStreak': 0,
        'completedThisWeek': 0,
        'completionRate': 0,
        'datesCompleted': [],
      });
      Navigator.pop(context);
    }
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: _icons.map((icon) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _selectedIcon == icon
                        ? LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _selectedIcon == icon ? null : Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon,
                      size: 28,
                      color:
                          _selectedIcon == icon ? Colors.white : Colors.black),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: _colors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _selectedColor == color
                        ? LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _selectedColor == color ? null : color,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Добавить привычку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Название привычки',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Выберите Значкок и цвет', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  decoration: BoxDecoration(
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
                    borderRadius: BorderRadius.circular(12), // Закругленные углы
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showIconPicker,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedColor.withOpacity(0.5), // Цвет из выбранного
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Icon(_selectedIcon, size: 20, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          children: [
                            // Вся строка для значка кликабельная
                            InkWell(
                              onTap: _showIconPicker,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Значок',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey, thickness: 0.5), // Разделитель
                            SizedBox(height: 8),
                            // Вся строка для цвета кликабельная
                            InkWell(
                              onTap: _showColorPicker,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Цвет',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _selectedColor, // Цвет из выбранного
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Выберите дни недели:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: _allDays.map((day) {
                    final bool isSelected = _selectedDays.contains(day); // Проверка выбранного дня
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedDays.remove(day);
                          } else {
                            _selectedDays.add(day);
                          }
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isSelected
                              ? LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                              : null,
                          color: isSelected ? null : Colors.grey[300], // Цвет для невыбранного
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          day.substring(0, 2), // Отображаем первые 2 буквы дня
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Готовые привычки:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3, // 3 контейнера в ряд
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildQuickHabit('Пить воду', Iconsax.cup, Colors.blue),
                    _buildQuickHabit('Читать', Iconsax.book, Colors.green),
                    _buildQuickHabit('Бег', Icons.directions_run_outlined, Colors.orange),
                    _buildQuickHabit('Медитация', Iconsax.heart, Colors.purple),
                    _buildQuickHabit('Тренировка', Iconsax.activity, Colors.red),
                    _buildQuickHabit('Зарядка', Iconsax.arrow, Colors.teal),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _createHabit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: primaryColor,
              ),
              child: Text('Создать',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHabit(String title, IconData icon, Color color) {
    List<String> _selectedDays = []; // Список выбранных дней для текущей привычки

    // Открыть модальное окно для выбора дней
    void _showDaysPicker() {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выберите дни недели для "$title"',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      children: _allDays.map((day) {
                        final bool isSelected = _selectedDays.contains(day);
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                _selectedDays.remove(day);
                              } else {
                                _selectedDays.add(day);
                              }
                            });
                          },
                          child: Container(
                            width: 90,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: isSelected
                                  ? LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : null,
                              color: isSelected ? null : Colors.grey[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              day.substring(0, 3), // Первые три буквы дня
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_selectedDays.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Выберите хотя бы один день недели'),
                            duration: Duration(seconds: 2),
                          ));
                          return;
                        }

                        // Создать привычку
                        await FirebaseFirestore.instance
                            .collection('habits')
                            .add({
                          'title': title,
                          'icon': _icons.indexOf(icon),
                          'color': _colors.indexOf(color),
                          'repeat': _selectedDays,
                          'streak': 0,
                          'bestStreak': 0,
                          'completedThisWeek': 0,
                          'completionRate': 0,
                          'datesCompleted': [],
                        });

                        Navigator.pop(context); // Закрыть модальное окно

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Привычка "$title" создана'),
                          duration: Duration(seconds: 2),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        'Создать привычку',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return GestureDetector(
      onTap: _showDaysPicker, // Открыть выбор дней недели
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
