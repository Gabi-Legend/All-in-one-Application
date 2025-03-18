import 'package:flutter/material.dart';

class SaveCancelButton extends StatelessWidget {
  final void Function()? onPressed;
  final String name;
  const SaveCancelButton(
      {super.key, required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(name));
  }
}
