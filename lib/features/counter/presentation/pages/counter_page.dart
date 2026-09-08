import 'package:flutter/material.dart';
import '../manager/counter_notifier.dart';
import '../widgets/counter_text.dart';

class CounterPage extends StatefulWidget {
  final String title;
  final CounterNotifier notifier;

  const CounterPage({
    super.key,
    required this.title,
    required this.notifier,
  });

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            CounterText(count: widget.notifier.counter),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.notifier.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
