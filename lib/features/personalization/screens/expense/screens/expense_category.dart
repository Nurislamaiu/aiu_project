import 'package:flutter/material.dart';

class SelectCategoryPage extends StatefulWidget {
  final Function(String, double) onAddExpense;

  SelectCategoryPage({required this.onAddExpense});

  @override
  _SelectCategoryPageState createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  // Категории с иконками и текущими суммами
  final Map<String, Map<String, dynamic>> expenseCategories = {
    'Продукты': {'icon': Icons.shopping_cart, 'amount': 0.0},
    'Транспорт': {'icon': Icons.directions_car, 'amount': 0.0},
    'Развлечения': {'icon': Icons.movie, 'amount': 0.0},
    'Образование': {'icon': Icons.school, 'amount': 0.0},
    'Одежда': {'icon': Icons.checkroom, 'amount': 0.0},
    'Коммунальные': {'icon': Icons.lightbulb, 'amount': 0.0},
    'Здоровье': {'icon': Icons.health_and_safety, 'amount': 0.0},
    'Другое': {'icon': Icons.more_horiz, 'amount': 0.0},
  };

  final TextEditingController _amountController = TextEditingController();

  void _showAmountDialog(BuildContext context, String category) {
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
                  setState(() {
                    expenseCategories[category]!['amount'] += amount;
                  });
                  widget.onAddExpense(category, amount);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите категорию'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 столбца
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: expenseCategories.keys.length,
          itemBuilder: (ctx, index) {
            final category = expenseCategories.keys.elementAt(index);
            final icon = expenseCategories[category]!['icon'] as IconData;
            final amount = expenseCategories[category]!['amount'] as double;
            return GestureDetector(
              onTap: () => _showAmountDialog(context, category),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 40, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      category,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
