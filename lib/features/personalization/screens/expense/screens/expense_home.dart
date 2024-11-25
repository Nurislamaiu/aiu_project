import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    'Продукты': {'icon': Icons.shopping_cart, 'color': Colors.red, 'amount': 0.0},
    'Транспорт': {'icon': Icons.directions_car, 'color': Colors.blue, 'amount': 0.0},
    'Развлечения': {'icon': Icons.movie, 'color': Colors.green, 'amount': 0.0},
    'Образование': {'icon': Icons.school, 'color': Colors.orange, 'amount': 0.0},
  };

  Map<String, Map<String, dynamic>> incomeCategories = {
    'Зарплата': {'icon': Icons.attach_money, 'color': Colors.green, 'amount': 0.0},
    'Бонусы': {'icon': Icons.card_giftcard, 'color': Colors.purple, 'amount': 0.0},
    'Продажа': {'icon': Icons.store, 'color': Colors.blue, 'amount': 0.0},
  };

  bool isExpense = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore(); // Загружаем данные из Firestore
  }


  Future<void> _loadDataFromFirestore() async {
    final userId = _currentUser!.uid;

    // Загружаем категории расходов
    final expenseSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseTracker')
        .doc('expenseCategories')
        .collection('categories')
        .get();

    // Загружаем категории доходов
    final incomeSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseTracker')
        .doc('incomeCategories')
        .collection('categories')
        .get();

    // Обновляем локальное состояние
    setState(() {
      for (var doc in expenseSnapshot.docs) {
        if (!expenseCategories.containsKey(doc.id)) {
          expenseCategories[doc.id] = {
            'icon': Icons.category, // Значение по умолчанию
            'color': Colors.red, // Значение по умолчанию
            'amount': doc['amount'] ?? 0.0,
          };
        } else {
          expenseCategories[doc.id]!['amount'] = doc['amount'];
        }
      }

      for (var doc in incomeSnapshot.docs) {
        if (!incomeCategories.containsKey(doc.id)) {
          incomeCategories[doc.id] = {
            'icon': Icons.category, // Значение по умолчанию
            'color': Colors.green, // Значение по умолчанию
            'amount': doc['amount'] ?? 0.0,
          };
        } else {
          incomeCategories[doc.id]!['amount'] = doc['amount'];
        }
      }
    });
  }


  Future<void> _addCategory(String name, IconData icon, Color color) async {
    final userId = _currentUser!.uid;

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

    await collection.doc(name).set({
      'icon': icon.codePoint,
      'color': color.value,
      'amount': 0.0,
    });

    setState(() {
      if (isExpense) {
        expenseCategories[name] = {'icon': icon, 'color': color, 'amount': 0.0};
      } else {
        incomeCategories[name] = {'icon': icon, 'color': color, 'amount': 0.0};
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
                decoration: InputDecoration(labelText: 'Введите название категории'),
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
                          color: selectedColor == color ? Colors.black : Colors.transparent,
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
                  _addCategory(name, selectedIcon!, selectedColor);
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

  // Диалог для добавления суммы в категорию
  void _showAddAmountDialog(BuildContext context, String category) {
    final TextEditingController _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Добавить сумму'),
          content: TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: 'Введите сумму'),
            keyboardType: TextInputType.number,
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
                final amount = double.tryParse(_amountController.text) ?? 0.0;
                if (amount > 0) {
                  _addAmount(category, amount);
                  _amountController.clear();
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

  // Добавление суммы для категории
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

    // Обновляем данные Firestore
    collection.doc(category).set({
      'amount': FieldValue.increment(amount), // Увеличиваем сумму
    }, SetOptions(merge: true));

    // Обновляем локальное состояние
    setState(() {
      if (isExpense) {
        expenseCategories[category]!['amount'] += amount;
      } else {
        incomeCategories[category]!['amount'] += amount;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final categories = isExpense ? expenseCategories : incomeCategories;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expense Tracker'),
            SizedBox(height: 4),
            Text(
              'Overall Balance: \$${(_getTotalIncomes() - _getTotalExpenses()).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ToggleButtons(
              isSelected: [isExpense, !isExpense],
              onPressed: (index) {
                setState(() {
                  isExpense = index == 0;
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              selectedColor: Colors.white,
              fillColor: Colors.blueAccent,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Expenses (\$${_getTotalExpenses().toStringAsFixed(2)})',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Incomes (\$${_getTotalIncomes().toStringAsFixed(2)})',
                    style: TextStyle(fontSize: 16),
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
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: categories.keys.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == categories.keys.length) {
                    return GestureDetector(
                      onTap: () => _showAddCategoryDialog(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 30, color: Colors.black),
                            SizedBox(height: 6),
                            Text(
                              'Добавить',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                        color: color,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 30, color: Colors.white),
                          SizedBox(height: 6),
                          Text(
                            category,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '\$${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.0,
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

  double _getTotalExpenses() {
    return expenseCategories.values.fold(
        0.0, (sum, category) => sum + (category['amount'] as double));
  }

  double _getTotalIncomes() {
    return incomeCategories.values.fold(
        0.0, (sum, category) => sum + (category['amount'] as double));
  }
}
