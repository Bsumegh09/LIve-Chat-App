import 'package:flutter/material.dart';
class LodingIndicator extends StatelessWidget {
  const LodingIndicator({Key?key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
