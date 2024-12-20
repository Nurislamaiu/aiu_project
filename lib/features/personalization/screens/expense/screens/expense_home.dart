import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthHandler(),
    );
  }
}

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return ExpenseTrackerHome();
        }
        return FutureBuilder(
          future: FirebaseAuth.instance.signInAnonymously(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Container();
          },
        );
      },
    );
  }
}

class ExpenseTrackerHome extends StatefulWidget {
  @override
  _ExpenseTrackerHomeState createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Map<String, Map<String, dynamic>> expenseCategories = {
    'Продукты': {
      'icon': Icons.shopping_cart,
      'color': Colors.red,
      'amount': 0.0
    },
    'Транспорт': {
      'icon': Icons.directions_car,
      'color': Colors.blue,
      'amount': 0.0
    },
    'Развлечения': {'icon': Icons.movie, 'color': Colors.green, 'amount': 0.0},
    'Образование': {
      'icon': Icons.school,
      'color': Colors.orange,
      'amount': 0.0
    },
  };

  Map<String, Map<String, dynamic>> incomeCategories = {
    'Зарплата': {
      'icon': Icons.attach_money,
      'color': Colors.green,
      'amount': 0.0
    },
    'Бонусы': {
      'icon': Icons.card_giftcard,
      'color': Colors.purple,
      'amount': 0.0
    },
    'Продажа': {'icon': Icons.store, 'color': Colors.blue, 'amount': 0.0},
  };

  bool isExpense = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    final userId = _currentUser!.uid;

    try {
      final expenseSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenseTracker')
          .doc('expenseCategories')
          .collection('categories')
          .get();

      final incomeSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenseTracker')
          .doc('incomeCategories')
          .collection('categories')
          .get();

      setState(() {
        for (var doc in expenseSnapshot.docs) {
          expenseCategories[doc.id] = {
            'icon': IconData(int.parse(doc['icon']), fontFamily: 'MaterialIcons'),
            'color': Color(doc['color']),
            'amount': doc['amount'] ?? 0.0,
          };
        }

        for (var doc in incomeSnapshot.docs) {
          incomeCategories[doc.id] = {
            'icon': IconData(int.parse(doc['icon']), fontFamily: 'MaterialIcons'),
            'color': Color(doc['color']),
            'amount': doc['amount'] ?? 0.0,
          };
        }
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddAmountDialog(BuildContext context, String category) {
    String enteredAmount = ""; // Текущая сумма

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              height: MediaQuery.of(context).size.height * 0.7, // Устанавливаем высоту
              child: Column(
                children: [
                  // Заголовок
                  Text(
                    'Введите сумму',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Поле для отображения текущей суммы
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      enteredAmount.isEmpty ? "0.00" : enteredAmount,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Цифровая клавиатура
                  Expanded(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 кнопки в ряду
                        childAspectRatio: 2, // Уменьшаем аспектное соотношение
                        crossAxisSpacing: 8, // Уменьшаем отступы между элементами
                        mainAxisSpacing: 8, // Уменьшаем вертикальные отступы
                      ),
                      itemCount: 12, // 10 цифр + кнопки "C" и "OK"
                      itemBuilder: (context, index) {
                        String buttonText;
                        if (index < 9) {
                          buttonText = (index + 1).toString();
                        } else if (index == 9) {
                          buttonText = "C";
                        } else if (index == 10) {
                          buttonText = "0";
                        } else {
                          buttonText = "OK";
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (buttonText == "C") {
                                enteredAmount = ""; // Очистка суммы
                              } else if (buttonText == "OK") {
                                if (enteredAmount.isNotEmpty) {
                                  _addAmount(category, double.parse(enteredAmount));
                                  Navigator.of(context).pop(); // Закрыть диалог
                                }
                              } else {
                                if (enteredAmount.length < 10) {
                                  enteredAmount += buttonText; // Добавление цифры
                                }
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              gradient: buttonText == "OK"
                                  ? LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlue],
                              )
                                  : buttonText == "C"
                                  ? LinearGradient(
                                colors: [Colors.redAccent, Colors.orange],
                              )
                                  : LinearGradient(
                                colors: [Colors.grey.shade300, Colors.grey.shade400],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                buttonText,
                                style: TextStyle(
                                  fontSize: 18, // Уменьшаем размер текста
                                  fontWeight: FontWeight.bold,
                                  color: buttonText == "OK" || buttonText == "C"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Кнопка отмены
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Отмена',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
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





  void _addAmount(String category, double amount) {
    final userId = _currentUser!.uid;

    // Определяем коллекцию (расходы или доходы)
    final collection = isExpense
        ? _firestore
            .collection('users')
            .doc(userId)
            .collection('expenseTracker')
            .doc('expenseCategories')
            .collection('categories')
        : _firestore
            .collection('users')
            .doc(userId)
            .collection('expenseTracker')
            .doc('incomeCategories')
            .collection('categories');

    // Обновляем данные в Firestore
    collection.doc(category).set({
      'amount': FieldValue.increment(amount),
      'icon': categories[category]!['icon'].toString(), // Сохраняем иконку как строку
      'color': categories[category]!['color'].value,   // Сохраняем цвет как int
    }, SetOptions(merge: true));


    // Обновляем локальное состояние для UI
    setState(() {
      if (isExpense) {
        expenseCategories[category]!['amount'] += amount;
      } else {
        incomeCategories[category]!['amount'] += amount;
      }
    });
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController _categoryController = TextEditingController();
    IconData? selectedIcon;
    Color selectedColor = Colors.red;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Добавить категорию'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _categoryController,
                decoration:
                    InputDecoration(labelText: 'Введите название категории'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<IconData>(
                value: selectedIcon,
                items: [
                  Icons.shopping_cart,
                  Icons.directions_car,
                  Icons.movie,
                  Icons.school,
                  Icons.attach_money,
                  Icons.card_giftcard,
                  Icons.store,
                ]
                    .map((icon) => DropdownMenuItem(
                          value: icon,
                          child: Row(
                            children: [
                              Icon(icon),
                              SizedBox(width: 10),
                              Text(icon.toString()),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (icon) {
                  selectedIcon = icon;
                },
                hint: Text('Выберите иконку'),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                children: [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal
                ].map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _categoryController.text.trim();
                if (name.isNotEmpty && selectedIcon != null) {
                  setState(() {
                    if (isExpense) {
                      expenseCategories[name] = {
                        'icon': selectedIcon!,
                        'color': selectedColor,
                        'amount': 0.0
                      };
                    } else {
                      incomeCategories[name] = {
                        'icon': selectedIcon!,
                        'color': selectedColor,
                        'amount': 0.0
                      };
                    }
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  double _getTotalExpenses() {
    return expenseCategories.values
        .fold(0.0, (sum, category) => sum + (category['amount'] as double));
  }

  double _getTotalIncomes() {
    return incomeCategories.values
        .fold(0.0, (sum, category) => sum + (category['amount'] as double));
  }

  double _getOverallBalance() {
    return _getTotalIncomes() - _getTotalExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final categories = isExpense ? expenseCategories : incomeCategories;

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overall Balance'),
            Text(
              '\$${_getOverallBalance().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isExpense = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isExpense ? Colors.blue : Colors.grey.shade300,
                    ),
                    child: Text(
                      'Expenses',
                      style: TextStyle(
                        color: isExpense ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isExpense = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isExpense ? Colors.grey.shade300 : Colors.blue,
                    ),
                    child: Text(
                      'Incomes',
                      style: TextStyle(
                        color: isExpense ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 2.5,
                ),
                itemCount: categories.keys.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == categories.keys.length) {
                    return GestureDetector(
                      onTap: () => _showAddCategoryDialog(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 24, color: Colors.black),
                              SizedBox(width: 5),
                              Text(
                                'Add Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final category = categories.keys.elementAt(index);
                  final icon = categories[category]!['icon'] as IconData;
                  final color = categories[category]!['color'] as Color;
                  final amount = categories[category]!['amount'] as double;

                  return GestureDetector(
                    onTap: () => _showAddAmountDialog(context, category),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color.withOpacity(0.2),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(icon, size: 18, color: color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  '\$${amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
