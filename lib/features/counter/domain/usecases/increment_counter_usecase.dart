import '../repositories/counter_repository.dart';

class IncrementCounterUseCase {
  final CounterRepository repository;

  IncrementCounterUseCase(this.repository);

  Future<void> execute() {
    return repository.incrementCounter();
  }
}
