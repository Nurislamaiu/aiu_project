import 'package:aiu_project/app.dart';
import 'package:aiu_project/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import 'habit_home.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

// Получить текущего пользователя
final User? user = _auth.currentUser;

// Получить уникальный идентификатор пользователя
final String? userId = user?.uid;


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
    if (userId == null) {
      Get.snackbar('Ошибка', 'Вы не авторизованы');
      return;
    }

    final String habitTitle = _titleController.text.trim();

    if (habitTitle.isEmpty) {
      Get.snackbar('Ошибка', 'Введите название привычки');
      return;
    }

    // Проверяем на наличие дубликатов
    final existingHabits = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId) // Переход к документу текущего пользователя
        .collection('habits')
        .where('title', isEqualTo: habitTitle)
        .get();

    if (existingHabits.docs.isNotEmpty) {
      Get.snackbar('Ошибка', 'Привычка с таким названием уже существует');
      return;
    }

    // Создаём привычку
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('habits') // Коллекция привычек текущего пользователя
        .add({
      'title': habitTitle,
      'icon': _icons.indexOf(_selectedIcon),
      'color': _selectedColor.value,
      'repeat': _selectedDays,
      'streak': 0,
      'bestStreak': 0,
      'completedThisWeek': 0,
      'completionRate': 0,
      'datesCompleted': [],
    });

    Get.offAll(NavigationMenu());
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
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Добавить привычку'),
        actions: [
          IconButton(onPressed: _createHabit, icon: Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        
              /// Контейнер для значка и цвета
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Выберите Значкок и цвет',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      borderRadius:
                          BorderRadius.circular(12), // Закругленные углы
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
                              color: _selectedColor.withOpacity(0.5),
                              // Цвет из выбранного
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Icon(_selectedIcon,
                                size: 20, color: Colors.white),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Значок',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 16, color: Colors.grey),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey, thickness: 0.5),
                              // Разделитель
                              SizedBox(height: 8),
                              // Вся строка для цвета кликабельная
                              InkWell(
                                onTap: _showColorPicker,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            color:
                                                _selectedColor, // Цвет из выбранного
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Icon(Icons.arrow_forward_ios,
                                            size: 16, color: Colors.grey),
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
        
              /// Контейнер для Выбор недели
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите дни недели:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Рассчитываем размер кнопок в зависимости от ширины экрана
                      final double availableWidth = constraints.maxWidth;
                      final double buttonSize =
                          availableWidth / 7 - 8; // Делим на 7 кнопок + отступы
        
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _allDays.map((day) {
                          final bool isSelected = _selectedDays.contains(day);
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
                              width: buttonSize.clamp(30, 60),
                              // Минимум 30, максимум 60
                              height: buttonSize.clamp(30, 60),
                              // Минимум 30, максимум 60
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
                                day.substring(0, 2), // Первые 2 буквы дня
                                style: TextStyle(
                                  fontSize: buttonSize.clamp(12, 16),
                                  // Размер текста зависит от кнопки
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
        
              /// Контейнер для готовых привычек
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Вычисляем размер карточки на основе ширины экрана
                      final double screenWidth =
                          MediaQuery.of(context).size.width;
                      final int crossAxisCount = screenWidth > 600
                          ? 4 // Для планшетов 4 колонки
                          : 3; // Для телефонов 3 колонки
                      final double cardWidth =
                          (screenWidth - (crossAxisCount - 1) * 12) /
                              crossAxisCount; // Вычисляем ширину карточки
        
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          // Динамическое количество колонок
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1, // Квадратные карточки
                        ),
                        itemCount: 6,
                        // Количество привычек
                        itemBuilder: (context, index) {
                          // Определяем параметры привычек
                          final List<Map<String, dynamic>> quickHabits = [
                            {
                              'title': 'Пить воду',
                              'icon': Iconsax.cup,
                              'color': _colors[0]
                            },
                            {
                              'title': 'Читать',
                              'icon': Iconsax.book,
                              'color': _colors[1]
                            },
                            {
                              'title': 'Бег',
                              'icon': Icons.directions_run_outlined,
                              'color': _colors[2]
                            },
                            {
                              'title': 'Медитация',
                              'icon': Iconsax.heart,
                              'color': _colors[3]
                            },
                            {
                              'title': 'Тренировка',
                              'icon': Iconsax.activity,
                              'color': _colors[4]
                            },
                            {
                              'title': 'Зарядка',
                              'icon': Iconsax.arrow,
                              'color': _colors[5]
                            },
                          ];
        
                          final habit = quickHabits[index];
        
                          return SizedBox(
                            width: cardWidth,
                            height: cardWidth,
                            child: _buildQuickHabit(
                              habit['title'],
                              habit['icon'],
                              habit['color'],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
        
              // /// Кнопка создать
              // ElevatedButton(
              //   onPressed: _createHabit,
              //   style: ElevatedButton.styleFrom(
              //     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     backgroundColor: primaryColor,
              //   ),
              //   child: Text('Создать',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickHabit(String title, IconData icon, Color color) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser; // Получаем текущего пользователя
    final String? userId = user?.uid; // Уникальный ID пользователя

    List<String> _selectedDays = List.from(_allDays); // Все дни недели по умолчанию

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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      crossAxisAlignment: WrapCrossAlignment.center,
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
                            width: 40,
                            height: 40,
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
                        if (userId == null) {
                          Get.snackbar('Ошибка', 'Вы не авторизованы');
                          return;
                        }

                        if (_selectedDays.isEmpty) {
                          Get.snackbar(
                              'Ошибка', 'Выберите хотя бы один день недели');
                          return;
                        }

                        // Проверка на дубликаты
                        final existingHabits = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('habits')
                            .where('title', isEqualTo: title)
                            .get();

                        if (existingHabits.docs.isNotEmpty) {
                          // Если привычка с таким названием уже существует
                          Get.snackbar(
                            'Ошибка',
                            'Привычка "$title" уже существует',
                          );
                          return;
                        }

                        // Сохранить привычку в Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('habits')
                            .add({
                          'title': title,
                          'icon': _icons.indexOf(icon),
                          // Сохраняем индекс значка
                          'color': color.value,
                          // Сохраняем значение цвета
                          'repeat': _selectedDays,
                          // Выбранные дни недели
                          'streak': 0,
                          'bestStreak': 0,
                          'completedThisWeek': 0,
                          'completionRate': 0,
                          'datesCompleted': [],
                          // Список выполненных дат
                        });

                        Get.offAll(NavigationMenu());
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
        padding: EdgeInsets.all(10),
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
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
