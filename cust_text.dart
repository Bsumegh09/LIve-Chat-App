import 'package:flutter/material.dart';
import 'package:talkme/utils/colours.dart';
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String )?onTap;
  const CustomTextField({Key?key,
    required this.controller,
    this.onTap,}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onTap,
      controller: controller,
      decoration:  const InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: buttonColour,
              width: 2,
            ),
           ),
            enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                    ),
      ),
    );
  }
}
