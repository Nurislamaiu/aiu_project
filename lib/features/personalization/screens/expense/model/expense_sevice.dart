import 'package:cloud_firestore/cloud_firestore.dart';

import 'expense_model.dart';

class ExpenseService {
  final CollectionReference _expensesCollection =
  FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(Expense expense) {
    return _expensesCollection.add(expense.toMap());
  }

  Stream<List<Expense>> getExpenses() {
    return _expensesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Expense.fromMap(doc.data() as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing document: $e');
          return null; // Handle invalid data gracefully
        }
      }).where((expense) => expense != null).cast<Expense>().toList();
    });
  }
}
