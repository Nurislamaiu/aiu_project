import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableProfileField extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const EditableProfileField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _EditableProfileFieldState createState() => _EditableProfileFieldState();
}

class _EditableProfileFieldState extends State<EditableProfileField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              controller: _controller,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: widget.label,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFF000DFF)),
                ),
              ),
              readOnly: !_isEditing,
              onEditingComplete: () {
                setState(() {
                  _isEditing = false;
                });
                widget.onChanged(_controller.text);
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check_circle : Icons.edit,
              color: _isEditing ? Colors.green : const Color(0xFF000DFF),
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });

              if (!_isEditing) {
                widget.onChanged(_controller.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
