              // StreamBuilder<List<Map<String, dynamic>>>(
              //   stream: _getLessons(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     }
              //
              //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //       return Text("Нет уроков");
              //     }
              //
              //     final lessons = snapshot.data!;
              //
              //     return ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: lessons.length,
              //       itemBuilder: (context, index) {
              //         final lesson = lessons[index];
              //         return Card(
              //           margin: EdgeInsets.symmetric(vertical: 8),
              //           child: ListTile(
              //             title: Text(lesson['subject']),
              //             subtitle: Text('${lesson['startTime']} - ${lesson['endTime']}'),
              //             trailing: Text(lesson['day']),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),