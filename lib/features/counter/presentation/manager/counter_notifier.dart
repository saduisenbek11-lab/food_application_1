import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_counter_usecase.dart';
import '../../domain/usecases/increment_counter_usecase.dart';

class CounterNotifier extends ChangeNotifier {
  final GetCounterUseCase getCounterUseCase;
  final IncrementCounterUseCase incrementCounterUseCase;

  int _counter = 0;
  int get counter => _counter;

  CounterNotifier({
    required this.getCounterUseCase,
    required this.incrementCounterUseCase,
  }) {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final entity = await getCounterUseCase.execute();
    _counter = entity.value;
    notifyListeners();
  }

  Future<void> increment() async {
    await incrementCounterUseCase.execute();
    await _loadCounter();
  }
}
