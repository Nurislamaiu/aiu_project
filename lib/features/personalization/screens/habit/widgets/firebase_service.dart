import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;

  // Получение аналитики привычки
  static Future<Map<String, dynamic>> getHabitAnalytics(String habitId) async {
    try {
      final doc = await _firestore.collection('habits').doc(habitId).get();

      if (!doc.exists) {
        throw Exception('Habit not found');
      }

      final data = doc.data()!;
      // Преобразуем completionDates из dynamic в List<DateTime>
      final completionDates = (data['completionDates'] as List<dynamic>?)
          ?.map((e) => (e as Timestamp).toDate())
          .toList() ?? [];

      // Пример вычислений аналитики
      int currentStreak = _calculateCurrentStreak(completionDates);
      int bestStreak = _calculateBestStreak(completionDates);
      double completionRate = (completionDates.length / 30) * 100;

      return {
        'title': data['title'],
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'completionRate': completionRate.toStringAsFixed(2),
        'completionDates': completionDates,
      };
    } catch (e) {
      throw Exception('Error fetching analytics: $e');
    }
  }

  static int _calculateCurrentStreak(List<DateTime> dates) {
    dates.sort();
    int streak = 0;
    DateTime today = DateTime.now();

    for (int i = dates.length - 1; i >= 0; i--) {
      if (dates[i].difference(today).inDays == -streak) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static int _calculateBestStreak(List<DateTime> dates) {
    dates.sort();
    int bestStreak = 0;
    int currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        currentStreak++;
        bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
      } else {
        currentStreak = 1;
      }
    }
    return bestStreak;
  }
}
