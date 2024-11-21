import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllLessonsScreen extends StatefulWidget {
  final String userId;

  AllLessonsScreen({required this.userId});

  @override
  _AllLessonsScreenState createState() => _AllLessonsScreenState();
}

class _AllLessonsScreenState extends State<AllLessonsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? selectedDay;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openOverlay(String day, BuildContext context, List<Map<String, dynamic>> lessons) {
    selectedDay = day;
    _overlayEntry = _createOverlayEntry(context, lessons);
    Overlay.of(context)!.insert(_overlayEntry!);
    _animationController.forward();
  }

  void _closeOverlay() {
    _animationController.reverse().then((_) {
      selectedDay = null;
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  OverlayEntry _createOverlayEntry(BuildContext context, List<Map<String, dynamic>> lessons) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeOverlay,
        child: Material(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedDay!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A6FF2),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          return ListTile(
                            title: Text(
                              lesson['subject'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Время: ${lesson['startTime']} - ${lesson['endTime']}\n"
                                  "Преподаватель: ${lesson['teacher']}\n"
                                  "Аудитория: ${lesson['room']}",
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // Удаляем урок из Firestore
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.userId)
                                    .collection('lessons')
                                    .doc(lesson['id']) // Используем уникальный id урока
                                    .delete();

                                // Закрываем оверлей и обновляем данные
                                _closeOverlay();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_overlayEntry != null) {
          _closeOverlay();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Все уроки",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF3A6FF2),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('lessons')
              .orderBy('day')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("Нет добавленных уроков"));
            }

            final lessons = snapshot.data!.docs;

            final Map<String, List<Map<String, dynamic>>> lessonsByDay = {
              'Пн': [],
              'Вт': [],
              'Ср': [],
              'Чт': [],
              'Пт': [],
              'Сб': [],
            };

            for (var lesson in lessons) {
              final data = lesson.data() as Map<String, dynamic>;
              final day = data['day'] ?? '';
              if (lessonsByDay.containsKey(day)) {
                lessonsByDay[day]!.add({
                  ...data,
                  'id': lesson.id, // Сохраняем id документа для удаления
                });
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: lessonsByDay.keys.length,
                itemBuilder: (context, index) {
                  final day = lessonsByDay.keys.toList()[index];
                  final dayLessons = lessonsByDay[day]!;

                  return GestureDetector(
                    onTap: dayLessons.isNotEmpty
                        ? () => _openOverlay(day, context, dayLessons)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3A6FF2),
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: dayLessons.isNotEmpty
                                ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: dayLessons.length,
                              itemBuilder: (context, index) {
                                final lesson = dayLessons[index];
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${lesson['subject']}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "${lesson['startTime']} - ${lesson['endTime']}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                                : Center(
                              child: Text(
                                "Нет уроков",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}