import 'package:flutter/material.dart';

import '../../../../../../../utils/constants/text_string.dart';

class RepTextField extends StatelessWidget {
  const RepTextField({
    super.key,
    required this.controller,
    this.isForDescription = false,
  });

  final TextEditingController controller;
  final bool isForDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      child: ListTile(
        title: TextFormField(
          decoration: InputDecoration(
              hintText: isForDescription ? TTexts.addNote : null,
              prefixIcon:
              isForDescription ? Icon(Icons.bookmark_border) : null),
          controller: controller,
          maxLines: isForDescription ? 1 : 3,
          onFieldSubmitted: (value) {},
        ),
      ),
    );
  }
}