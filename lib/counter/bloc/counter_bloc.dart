import 'package:bloc_app_test/counter/bloc/counter_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      if (event is CounterIncremented) {
        emit(state + 1);
      }
      if (event is CounterDecremented) {
        emit(state - 1);
      }
    });
  }
}
