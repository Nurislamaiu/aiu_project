import 'package:flutter/material.dart';

class HabitWeeklyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final day = DateTime.now().subtract(Duration(days: 6 - index));
        return Column(
          children: [
            Text(
              ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][day.weekday % 7],
              style: TextStyle(color: Color(0xFF5E5CE6)),
            ),
            CircleAvatar(
              backgroundColor: Color(0xFF000DFF),
              child: Text(day.day.toString(),
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      }),
    );
  }
}
