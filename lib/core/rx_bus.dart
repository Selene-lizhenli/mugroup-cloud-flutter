import 'package:rxdart/rxdart.dart';

class RxBus {
  final PublishSubject<dynamic> _bus;

  RxBus() : _bus = PublishSubject<dynamic>();

  void dispatch(event) => _bus.add(event);

  Stream<T> on<T>() => _bus.stream.whereType<T>();

  void dispose() => _bus.close();
}
