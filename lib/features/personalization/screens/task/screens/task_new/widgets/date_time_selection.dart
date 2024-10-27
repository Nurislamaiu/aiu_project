import 'package:flutter/material.dart';

import '../../../../../../../utils/constants/text_string.dart';

class DateTimeSelectionWidget extends StatelessWidget {
  const DateTimeSelectionWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.time,
  });

  final VoidCallback onTap;
  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(20.0),
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100),
              child: Center(
                child: Text(
                  time,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
