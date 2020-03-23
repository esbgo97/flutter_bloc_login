import 'package:bloc_pattern/bloc/transition.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'supervisor.dart';

abstract class Bloc<Event, State> {
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();
  BehaviorSubject<State> _stateSubject;

  State get initialState;

  State get currentState => _stateSubject.value;

  Bloc() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);
    _bindStateSubject();
  }

  Stream<State> mapEventToState(Event event);

  @mustCallSuper
  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }

  void dispatch(Event event) {
    try {
      BlocSupervisor.delegate.onEvent(this, event);
      onEvent(event);
      _eventSubject.sink.add(event);
    } catch (err) {
      _handleError(err);
    }
  }

  void onError(Object err, StackTrace stack) => null;

  void onEvent(Event event) => null;

  void onTransition(Transition<Event, State> transition) => null;

  Stream<State> transform(
      Stream<Event> events, Stream<State> next(Event event)) {
    return events.asyncExpand(next);
  }

  void _bindStateSubject() {
    Event currentEvent;
    transform(_eventSubject, (Event event) {
      currentEvent = event;
      return mapEventToState(currentEvent).handleError(_handleError);
    }).forEach((State nextState) {
      if (currentState == nextState || _stateSubject.isClosed) return;
      final transition = Transition(
          currentState: currentState,
          event: currentEvent,
          nextState: nextState);

      BlocSupervisor.delegate.onTransition(this, transition);
      onTransition(transition);
      _stateSubject.sink.add(nextState);
    });
  }

  void _handleError(Object err, [StackTrace stackTrace]) {
    BlocSupervisor.delegate.onError(this, err, stackTrace);
    onError(err, stackTrace);
  }
}
