import 'package:flutter/material.dart';

class CounterText extends StatelessWidget {
  final int count;

  const CounterText({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
