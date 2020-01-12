import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Controller<T> {
  Map<T, BehaviorSubject<dynamic>> controlers = {};
  Map<T, Type> types = {};

  ValueObservable<S> streamOf<S>(T key) {
    if (types[key] == S) return controlers[key].stream;
    return null;
  }

  S getValue<S>(T key) {
    return (controlers[key] as BehaviorSubject<S>).value;
  }

  void push<S>(T key, S value) {
    if (types[key] == S) controlers[key].sink.add(value);
  }

  void add<S>(T key, S inivalue) {
    controlers[key] = BehaviorSubject<S>();
    controlers[key].sink.add(inivalue);
    types[key] = S;
  }

  void addControler<S>(T key, BehaviorSubject<S> streamController) {
    controlers[key] = streamController;
    types[key] = S;
  }

  void dispose() {
    controlers.forEach(
        (T, StreamController streamController) => streamController.close());
  }
}
