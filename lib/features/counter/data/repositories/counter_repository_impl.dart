import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  int _counter = 0;

  @override
  Future<CounterEntity> getCounter() async {
    return CounterEntity(value: _counter);
  }

  @override
  Future<void> incrementCounter() async {
    _counter++;
  }
}
